#!/usr/bin/env python3
"""Fragment tests for scripts/deploy.d/82_zsh_completions.zsh.

Runs the REAL fragment against a sandbox XDG_CACHE_HOME with fake tool shims
on PATH — no real tools, no network. Covers (each under BOTH zsh and
/bin/bash, with a SPACE inside every sandbox path):

  T1  dry-run: zero writes (no cache dir, no files created)
  T2  generator exit!=0 with a VALID-looking first line: old completion file
      preserved byte-identical, no replacement (the pipe-status masking the
      old pipeline allowed)
  T3  generator succeeds but output lacks #compdef on line 1: old file
      preserved
  T4  happy path: valid #compdef output replaces the old file atomically
  T5  bun/opencode ARE invoked with SHELL basename=zsh and their SHELL-zsh
      output installs as _bun/_opencode (the pluto root cause: deploy runs
      under bash, and both tools pick language from $SHELL, not argv)
"""

import os
import subprocess
import tempfile
import unittest

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
FRAGMENT = os.path.join(REPO, "scripts", "deploy.d", "82_zsh_completions.zsh")

# Distinct old/new byte streams for the ACTUAL generator destination (_uv):
# preservation assertions are only meaningful when the generator's would-be
# output differs from the seeded file.
OLD_UV = "#compdef uv\n_uv_old_marker_DO_NOT_REGENERATE() {}\n"
NEW_UV = "#compdef uv\n_uv_new_from_generator() {}\n"

FAKE_TOOLS = {
    # exits 1 AFTER emitting a valid header line (partial-output trap)
    "partgen": "#!/bin/bash\nprintf '%s\\n' '#compdef uv'; printf '%s\\n' '_uv_new_from_generator() {}'; exit 1\n",
    # succeeds, wrong header (bash-format, like `bun completions`)
    "bashgen": "#!/bin/bash\nprintf '%s\\n' '#!/usr/bin/env bash'; printf '%s\\n' '_file_arguments() {}'\n",
}


class CompletionsFragmentTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix="zsh-comp-")
        # Stub ZDOTDIR: the user's ~/.zshenv (dotfiles env.d) re-prepends mise
        # dirs ahead of any PATH we set, which would let REAL tools win over
        # the shims. An empty .zshenv keeps the child shell's PATH exactly ours.
        zdotdir = os.path.join(self.tmp, "zdotdir")
        os.makedirs(zdotdir)
        open(os.path.join(zdotdir, ".zshenv"), "w").close()
        # SPACE in every path — quoting bugs fail everything, not one test
        self.bin_dir = os.path.join(self.tmp, "fake bin")
        self.cache = os.path.join(self.tmp, "cache base", "zsh", "fpath")
        self.tmpdir = os.path.join(self.tmp, "tmp base")
        os.makedirs(self.bin_dir)
        os.makedirs(self.cache)
        os.makedirs(self.tmpdir)
        os.chmod(self.bin_dir, 0o755)
        for name, body in FAKE_TOOLS.items():
            p = os.path.join(self.bin_dir, name)
            with open(p, "w") as f:
                f.write(body)
            os.chmod(p, 0o755)
        # Shadow the fragment's stock generators so real tools from the
        # parent PATH (sops/codex/sg/uv/bun/opencode) are never invoked — the
        # suite must be hermetic. Default: exit 1, no output; tests override.
        for name in ("uv", "sops", "codex", "sg", "bun", "opencode"):
            p = os.path.join(self.bin_dir, name)
            with open(p, "w") as f:
                f.write("#!/bin/bash\nexit 1\n")
            os.chmod(p, 0o755)
        # `have` shim with real semantics
        with open(os.path.join(self.bin_dir, "have"), "w") as f:
            f.write('#!/bin/bash\ncommand -v "$1" >/dev/null 2>&1\n')
        os.chmod(os.path.join(self.bin_dir, "have"), 0o755)
        # A lock-style generators override is not supported by the fragment;
        # tests use the real generators list minus uninstalled tools.
        # The REAL destination of the `uv` generator, seeded per-test with
        # distinct old bytes so preserve-vs-replace assertions are meaningful.
        self.uv_dest = os.path.join(self.cache, "_uv")
        self.env = dict(os.environ)
        self.env.update(
            ZDOTDIR=zdotdir,
            XDG_CACHE_HOME=os.path.join(self.tmp, "cache base"),
            TMPDIR=self.tmpdir,
            PATH=self.bin_dir + os.pathsep + self.env["PATH"],
            DEPLOY_DRY_RUN="0",
        )
        # Same hazard for bash: a non-interactive `bash -c` sources $BASH_ENV,
        # and on fleet hosts that file (~/.config/bash/env.sh) re-prepends the
        # mise shims ahead of our fake bin, so the REAL uv/bun/codex ran and
        # T2-T4 failed under /bin/bash (2026-10-31). CI has no BASH_ENV, which
        # is why only fleet hosts saw it.
        self.env.pop("BASH_ENV", None)
        self.env.pop("ENV", None)
        # ensure the stock generators that would hit real tools are absent
        # from PATH (fragment skips them via `have`) — nothing real is called.

    def run_fragment(self, shell, dry_run=False):
        env = dict(self.env)
        env["DEPLOY_DRY_RUN"] = "1" if dry_run else "0"
        # The fragment uses `return 0` in its dry-run gate — valid only in a
        # SOURCED context (deploy drivers source fragments; `return` at top
        # level of an executed script errors under bash and falls through).
        # Source it the way the drivers do.
        return subprocess.run(
            [shell, "-c", f'. "{FRAGMENT}"'], env=env, capture_output=True, text=True, timeout=120
        )

    def tearDown(self):
        subprocess.run(["chmod", "-R", "u+w", self.tmp], check=False)
        subprocess.run(["rm", "-rf", self.tmp], check=False)

    def snapshot(self):
        out = {}
        for root, _, files in os.walk(self.tmp):
            for fn in files:
                p = os.path.join(root, fn)
                with open(p, "rb") as f:
                    out[p] = f.read()
        return out

    def test_t1_dry_run_zero_writes(self):
        for shell in ("zsh", "/bin/bash"):
            with self.subTest(shell=shell):
                before = self.snapshot()
                r = self.run_fragment(shell, dry_run=True)
                self.assertEqual(r.returncode, 0, r.stderr)
                self.assertIn("would: generate _bun, _uv, _sops, _codex, _opencode, _sg", r.stdout)
                self.assertEqual(self.snapshot(), before, "dry-run wrote files")
                # no generator temp files leaked into TMPDIR
                self.assertEqual(os.listdir(self.tmpdir), [], "dry-run wrote tmp files")

    def test_t2_generator_failure_preserves_old_file(self):
        for shell in ("zsh", "/bin/bash"):
            with self.subTest(shell=shell):
                with open(self.uv_dest, "w") as f:
                    f.write(OLD_UV)
                # fake `uv` that emits the NEW bytes THEN dies (rc=1): the
                # partial-but-valid-looking output must NOT be installed
                p = os.path.join(self.bin_dir, "uv")
                with open(p, "w") as f:
                    f.write(FAKE_TOOLS["partgen"])
                os.chmod(p, 0o755)
                r = self.run_fragment(shell)
                self.assertEqual(r.returncode, 0, r.stderr)
                self.assertIn("rc=1", r.stdout, "failure line lacks named rc diagnostic")
                with open(self.uv_dest) as f:
                    self.assertEqual(f.read(), OLD_UV, "failed generator replaced old completion")
                self.assertEqual(os.listdir(self.tmpdir), [], "tmp files leaked")
                os.remove(p)

    def test_t3_missing_header_preserves_old_file(self):
        for shell in ("zsh", "/bin/bash"):
            with self.subTest(shell=shell):
                with open(self.uv_dest, "w") as f:
                    f.write(OLD_UV)
                p = os.path.join(self.bin_dir, "uv")
                with open(p, "w") as f:
                    f.write(FAKE_TOOLS["bashgen"])  # bash-format, no #compdef
                os.chmod(p, 0o755)
                r = self.run_fragment(shell)
                self.assertEqual(r.returncode, 0, r.stderr)
                self.assertIn("failed to generate _uv", r.stdout)
                with open(self.uv_dest) as f:
                    self.assertEqual(f.read(), OLD_UV, "header-less output replaced old completion")
                os.remove(p)

    def test_t4_valid_output_replaces_atomically(self):
        for shell in ("zsh", "/bin/bash"):
            with self.subTest(shell=shell):
                with open(self.uv_dest, "w") as f:
                    f.write(OLD_UV)
                p = os.path.join(self.bin_dir, "uv")
                with open(p, "w") as f:
                    f.write("#!/bin/bash\nprintf '%s\\n' '' '#compdef uv' '_uv_new_from_generator() {}'\n")
                os.chmod(p, 0o755)
                r = self.run_fragment(shell)
                self.assertEqual(r.returncode, 0, r.stderr)
                self.assertIn("wrote _uv", r.stdout)
                with open(self.uv_dest) as f:
                    self.assertEqual(f.read(), NEW_UV, "valid output did not replace old bytes with new")
                # success path consumed tmp via mv; tmp_raw must be cleaned too
                self.assertEqual(os.listdir(self.tmpdir), [], "raw temp left after successful generation")
                os.remove(p)

    def test_t5_bun_opencode_generated_via_shell_zsh(self):
        for shell in ("zsh", "/bin/bash"):
            with self.subTest(shell=shell):
                # Language-by-SHELL stub: emits #compdef zsh only when $SHELL
                # basenames to zsh, else bash-format (what pluto's deploys saw).
                for name in ("bun", "opencode"):
                    body = (
                        "#!/bin/bash\n"
                        'case "$(basename "$SHELL")" in\n'
                        "  zsh) printf '%s\\n' '#compdef @@NAME@@' '_@@NAME@@(){}' ;;\n"
                        "  *)   printf '%s\\n' '#!/usr/bin/env bash' '_f(){}' ;;\n"
                        "esac\n".replace("@@NAME@@", name)
                    )
                    p = os.path.join(self.bin_dir, name)
                    with open(p, "w") as f:
                        f.write(body)
                    os.chmod(p, 0o755)
                r = self.run_fragment(shell)
                self.assertEqual(r.returncode, 0, r.stderr)
                self.assertIn("wrote _bun", r.stdout, "bun not generated (SHELL not forced zsh?)")
                self.assertIn("wrote _opencode", r.stdout, "opencode not generated")
                for dest in ("_bun", "_opencode"):
                    with open(os.path.join(self.cache, dest)) as f:
                        self.assertEqual(f.read().splitlines()[0], "#compdef " + dest[1:])
                self.assertEqual(os.listdir(self.tmpdir), [], "raw temps left after bun/opencode generation")
                os.remove(os.path.join(self.bin_dir, "bun"))
                os.remove(os.path.join(self.bin_dir, "opencode"))


if __name__ == "__main__":
    unittest.main(verbosity=2)
