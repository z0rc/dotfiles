#!/usr/bin/env python3
"""Dotfiles-lane Pluto contracts, offline in a disposable HOME.

Complements test-nixos-integration.py (Sol's suite) with the contracts this
lane owns: driver dry-run zero-mutation (incl. a caller-supplied XDG_STATE_HOME
with spaces), sibling env overrides + worktree `.git`-file detection, mise
upgrade gating, per-package npm installs with the --libc override, and the
Pluto fork installer consuming the real pin checker's validated selector. No
network, no host mutations; runs on macOS and Linux with bash + zsh.
"""
from pathlib import Path
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
SHELLS = [str(Path("/bin/bash")) if Path("/bin/bash").is_file() else shutil.which("bash"),
          shutil.which("zsh")]
if not all(SHELLS):
    raise SystemExit("these tests require bash and zsh on PATH")


class LaneContracts(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-lane-")
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.home = self.base / "home"
        self.home.mkdir()
        self.repo = self.base / "repo"          # fake dotfiles checkout (SCRIPT_DIR)
        self.bin = self.base / "bin"
        self.bin.mkdir(parents=True)
        self.calls = self.base / "calls"
        self.mise_args = self.base / "mise-argv"
        for tool in ("bash", "zsh", "sh", "uname", "date", "cat", "sed", "tail",
                     "head", "tee", "xargs",
                     "grep", "find", "sort", "mktemp", "mkdir", "ln", "rm",
                     "cp", "mv", "readlink", "basename", "dirname", "ldd",
                     "chmod", "git", "systemctl"):
            source = shutil.which(tool)
            if source:
                (self.bin / tool).symlink_to(source)
        self.env = {
            "HOME": str(self.home), "USER": "lane", "PATH": str(self.bin),
            "CALLS": str(self.calls), "TMPDIR": str(self.base),
            "MISE_ARGS": str(self.mise_args),
            "XDG_CONFIG_HOME": str(self.home / ".config"),
            "XDG_STATE_HOME": str(self.home / ".local/state"),
            "XDG_CACHE_HOME": str(self.home / ".cache"),
            "XDG_DATA_HOME": str(self.home / ".local/share"),
            "SCRIPT_DIR": str(self.repo), "DOTFILES_OS": "Linux",
            "DOTFILES_ARCH": "x86_64", "DOTFILES_SKIP_BREW": "1",
            "DEPLOY_DRY_RUN": "0", "DEPLOY_FORCE": "0",
            "upgrade_mode": "false", "BASH_ENV": "/dev/null",
            "ZDOTDIR": str(self.home), "FAKE_HOST": "fixture",
            "PULL_RC": "0", "DEPLOY_RC": "0",
            "FAKE_GIT_HOOKS_DIR": str(self.base / "hooks"),
        }
        self.fake("uname", 'case "$1" in -s) echo Linux;; -m) echo x86_64;; '
                           '-n) echo "$FAKE_HOST";; esac')
        self.fake("git", 'printf "git %s\\n" "$*" >> "$CALLS"; '
                         'if [ "$1" = -C ]; then shift 2; fi; '
                         'case $1 in rev-parse) echo "$FAKE_GIT_HOOKS_DIR";; esac; exit "$PULL_RC"')
        self.fake("systemctl", 'printf "systemctl %s\\n" "$*" >> "$CALLS"; exit 0')
        self.fake("ldd", 'echo "ldd (GNU GLIBC) 2.40"')
        # Keep every installer offline, even if a fragment takes an unexpected
        # branch. These are executable fixtures, never the host's installers.
        self.fake("curl", 'printf "FORBIDDEN curl %s\\n" "$*" >> "$CALLS"; exit 99')
        for tool in ("coderabbit", "cargo", "linear-cli", "node", "corepack"):
            self.fake(tool, f'printf "{tool} %s\\n" "$*" >> "$CALLS"; exit 0')

    def tearDown(self):
        self.assertNotIn("FORBIDDEN", self.log(), "unexpected download attempt")

    def fake(self, name, body):
        target = self.bin / name
        if target.is_symlink():
            target.unlink()
        target.write_text("#!/bin/sh\n" + body + "\n")
        target.chmod(0o755)

    def copy(self, relative, dest=None):
        target = (self.repo / relative) if dest is None else Path(dest)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(ROOT / relative, target)
        return target

    def run_shell(self, shell, code, *args, **kw):
        result = subprocess.run([shell, "-c", code, "lane", *map(str, args)],
                                env=self.env, text=True, capture_output=True, timeout=30)
        if kw.get("allow_fail"):
            return result
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result.stdout + result.stderr

    def log(self):
        return self.calls.read_text() if self.calls.exists() else ""

    def fake_mise(self):
        # Model the CLI boundary, not mise internals: exec forwards argv after
        # -- verbatim and propagates its status (including an npm failure).
        self.fake("mise", '''printf "mise %s\\n" "$*" >> "$CALLS"
printf '%s\\0' "$@" >> "$MISE_ARGS"
printf '\\n' >> "$MISE_ARGS"
case "$1" in
    install)
        if [ "${MISE_INSTALL_RC:-0}" != 0 ]; then
            echo "synthetic install failure"
            exit "$MISE_INSTALL_RC"
        fi
        ;;
    exec)
        shift
        while [ "$#" -gt 0 ] && [ "$1" != -- ]; do shift; done
        [ "$#" -gt 0 ] || exit 98
        shift
        exec "$@"
        ;;
esac
exit 0''')

    def xdg_with_spaces(self):
        xdg = self.base / "state dir with spaces"
        self.env["XDG_STATE_HOME"] = str(xdg)
        return xdg

    # ── drivers ───────────────────────────────────────────────────────────

    def test_driver_dry_run_never_touches_state_home(self):
        self.copy("scripts/deploy.d/lib/helpers.zsh")
        self.copy("deploy.zsh", self.repo / "deploy.zsh")
        self.copy("deploy.bash", self.repo / "deploy.bash")
        xdg = self.xdg_with_spaces()
        self.env["DEPLOY_DRY_RUN"] = "1"
        for shell, driver in zip(SHELLS, ("deploy.bash", "deploy.zsh")):
            with self.subTest(shell=shell, driver=driver):
                self.run_shell(shell, '"$1" --dry-run', self.repo / driver)
                self.assertFalse(xdg.exists(),
                                "dry-run created $XDG_STATE_HOME (log setup ran)")
                self.assertFalse((xdg / "dotfiles-deploy.log").exists())

    def test_driver_real_run_logs_into_supplied_xdg_with_spaces(self):
        self.copy("scripts/deploy.d/lib/helpers.zsh")
        self.copy("deploy.zsh", self.repo / "deploy.zsh")
        self.copy("deploy.bash", self.repo / "deploy.bash")
        xdg = self.xdg_with_spaces()
        for shell, driver in zip(SHELLS, ("deploy.bash", "deploy.zsh")):
            with self.subTest(shell=shell, driver=driver):
                (xdg / "dotfiles-deploy.log").unlink(missing_ok=True)
                self.run_shell(shell, '"$1"', self.repo / driver)
                self.assertTrue((xdg / "dotfiles-deploy.log").is_file(),
                                "real run must still tee the deploy log (quoted path)")
                self.assertIn("deploy started", (xdg / "dotfiles-deploy.log").read_text())

    # ── sibling overrides + worktree .git-file ────────────────────────────

    def test_sibling_env_overrides_and_worktree_git_file(self):
        self.copy("scripts/deploy.d/lib/helpers.zsh")
        for name in ("65_secrets", "66_infra", "67_agents", "68_encoding"):
            self.copy(f"scripts/deploy.d/{name}.zsh")
        # Siblings at overridden paths, each a WORKTREE (`.git` is a file).
        secrets = self.base / "over rides/secrets"
        infra = self.base / "over rides/infra"
        agents = self.base / "over rides/agents"
        encoding = self.base / "over rides/encoding"
        for sibling in (secrets, infra, agents, encoding):
            sibling.mkdir(parents=True)
            (sibling / ".git").write_text("gitdir: /main/repo/.git/worktrees/x\n")
        for name, sibling in (("infra", infra), ("agents", agents), ("encoding", encoding)):
            deploy = sibling / "deploy"
            deploy.write_text('#!/bin/sh\n'
                              f'printf "{name} %s DOTFILES_DIR=%s\\n" "$*" '
                              '"${DOTFILES_DIR:-}" >> "$CALLS"\nexit "$DEPLOY_RC"\n')
            deploy.chmod(0o755)
        key = self.home / ".config/sops/age/keys.txt"
        key.parent.mkdir(parents=True)
        key.write_text("synthetic lane fixture, not a key\n")
        (self.repo / "scripts").mkdir(parents=True, exist_ok=True)
        renderer = self.repo / "scripts/secrets-render.zsh"
        renderer.write_text('printf "render dry=%s\\n" "$DEPLOY_DRY_RUN" >> "$CALLS"\n')
        self.env.update(SECRETS_DIR=str(secrets), INFRA_DIR=str(infra),
                        AGENTS_DIR=str(agents), ENCODING_DIR=str(encoding))
        for shell in SHELLS:
            with self.subTest(shell=shell):
                self.calls.unlink(missing_ok=True)
                hooks = self.base / "hooks"
                hooks.mkdir(exist_ok=True)
                # scripts/post-merge must exist in the (worktree) secrets repo
                # for the hook leg; verify the symlink lands in the
                # --git-path hooks dir the fake git reports.
                pm = secrets / "scripts" / "post-merge"
                pm.parent.mkdir(parents=True, exist_ok=True)
                pm.write_text("#!/bin/sh\nexit 0\n")
                pm.chmod(0o755)
                self.run_shell(shell, 'for f in "$@"; do . "$f" || exit; done',
                               self.repo / "scripts/deploy.d/lib/helpers.zsh",
                               self.repo / "scripts/deploy.d/65_secrets.zsh",
                               self.repo / "scripts/deploy.d/66_infra.zsh",
                               self.repo / "scripts/deploy.d/67_agents.zsh",
                               self.repo / "scripts/deploy.d/68_encoding.zsh")
                calls = self.log()
                self.assertIn("render dry=0", calls)
                self.assertIn(f"git -C {secrets} pull --ff-only", calls)
                self.assertIn(f"git -C {infra} pull --ff-only", calls)
                self.assertIn(f"git -C {agents} pull --ff-only", calls)
                self.assertNotIn("clone", calls,
                                 "a present worktree must never be re-cloned")
                self.assertTrue((hooks / "post-merge").is_symlink(),
                                "post-merge hook must land in the --git-path hooks dir")
                self.assertIn("infra ", calls)
                self.assertIn("agents ", calls)
                self.assertIn("encoding ", calls)
                self.assertIn("systemctl --user daemon-reload", calls)

    def test_siblings_dry_run_still_zero_mutation(self):
        self.copy("scripts/deploy.d/lib/helpers.zsh")
        for name in ("65_secrets", "66_infra", "67_agents", "68_encoding"):
            self.copy(f"scripts/deploy.d/{name}.zsh")
        self.env["DEPLOY_DRY_RUN"] = "1"
        for shell in SHELLS:
            with self.subTest(shell=shell):
                self.calls.unlink(missing_ok=True)
                self.run_shell(shell, 'for f in "$@"; do . "$f" || exit; done',
                               self.repo / "scripts/deploy.d/lib/helpers.zsh",
                               self.repo / "scripts/deploy.d/65_secrets.zsh",
                               self.repo / "scripts/deploy.d/66_infra.zsh",
                               self.repo / "scripts/deploy.d/67_agents.zsh",
                               self.repo / "scripts/deploy.d/68_encoding.zsh")
                self.assertEqual(self.log(), "",
                                 "dry-run chain must invoke no fake tool at all")

    # ── mise upgrade gating ───────────────────────────────────────────────

    def test_mise_upgrade_only_under_upgrade_mode(self):
        self.copy("scripts/deploy.d/lib/helpers.zsh")
        fragment = self.copy("scripts/deploy.d/50_mise.zsh")
        self.fake("mise", 'printf "mise %s\\n" "$*" >> "$CALLS"; exit 0')
        for shell in SHELLS:
            with self.subTest(shell=shell):
                self.calls.unlink(missing_ok=True)
                self.run_shell(shell, '. "$1"; upgrade_mode=false; . "$2"',
                               self.repo / "scripts/deploy.d/lib/helpers.zsh", fragment)
                calls = self.log()
                self.assertIn("mise install", calls)
                self.assertNotIn("mise upgrade", calls,
                                 "plain deploy must not upgrade pinned tools")
                self.calls.unlink(missing_ok=True)
                self.run_shell(shell, '. "$1"; upgrade_mode=true; . "$2"',
                               self.repo / "scripts/deploy.d/lib/helpers.zsh", fragment)
                self.assertIn("mise upgrade --yes", self.log())

    # ── npm globals: local inventory, integrity, upgrade, failure isolation ─

    def npm_fixture(self, specs, versions):
        import json
        self.copy("scripts/deploy.d/lib/helpers.zsh")
        fragment = self.copy("scripts/deploy.d/70_runtime_installs.zsh")
        (self.repo / ".default-npm-packages").write_text("\n".join(specs) + "\n")
        self.npm_specs = list(specs)
        self.fake_mise()
        # Only this fixture exposes real node: it runs the production local
        # parser, never npm APIs or a network operation. All npm calls are fake.
        node = shutil.which("node")
        self.assertIsNotNone(node, "npm inventory contracts require real node")
        resolved = subprocess.check_output(
            [node, "-p", "process.execPath"], text=True).strip()
        (self.bin / "node").unlink()
        (self.bin / "node").symlink_to(resolved)
        self.npm_prefix = self.home / ".local/share/mise/installs/node/24 with spaces"
        (self.npm_prefix / "bin").mkdir(parents=True)
        self.inventory = self.base / "inventory.json"
        self.inventory.write_text(json.dumps({"dependencies": {
            name: {"version": version} for name, version in versions.items()}}))
        self.npm_argv = self.base / "npm-argv.jsonl"
        self.npm_installed = self.base / "installed.jsonl"
        self.env.update(NPM_FIXTURE_PREFIX=str(self.npm_prefix),
                        NPM_FIXTURE_INVENTORY=str(self.inventory),
                        NPM_FIXTURE_ARGV=str(self.npm_argv),
                        NPM_FIXTURE_INSTALLED=str(self.npm_installed),
                        NPM_INVENTORY_MODE="valid", NPM_FAIL_SPEC="",
                        T3_PROBE_RC="0", PI_PROBE_RC="0",
                        NPM_CONFIG_USERCONFIG="/dev/null")
        # Model process results, not the implementation's install decisions.
        # Failed npm transactions install nothing; successful ones record specs.
        npm = self.bin / "npm"
        npm.write_text("#!" + sys.executable + "\n" + '''import json, os, sys
from pathlib import Path
args = sys.argv[1:]
with open(os.environ["NPM_FIXTURE_ARGV"], "a") as stream:
    stream.write(json.dumps(args) + "\\n")
if args == ["prefix", "-g"]:
    print(os.environ["NPM_FIXTURE_PREFIX"])
elif args == ["ls", "-g", "--depth", "0", "--json"]:
    mode = os.environ["NPM_INVENTORY_MODE"]
    print("not JSON" if mode == "garbage" else
          Path(os.environ["NPM_FIXTURE_INVENTORY"]).read_text())
    sys.exit(1 if mode == "fail" else 0)
elif args and args[0] == "install":
    specs = [arg for arg in args[1:] if not arg.startswith("-")]
    if os.environ["NPM_FAIL_SPEC"] in specs:
        print("synthetic npm failure for " + os.environ["NPM_FAIL_SPEC"], file=sys.stderr)
        sys.exit(1)
    with open(os.environ["NPM_FIXTURE_INSTALLED"], "a") as stream:
        for spec in specs:
            stream.write(json.dumps(spec) + "\\n")
elif args and args[0] in ("uninstall", "rebuild"):
    pass
else:
    sys.exit("unexpected npm operation: " + repr(args))
''')
        npm.chmod(0o755)
        (self.npm_prefix / "bin/npm").symlink_to(npm)
        for cli, rc in (("t3", "T3_PROBE_RC"), ("pi", "PI_PROBE_RC")):
            self.fake(cli, f'printf "{cli} %s\\n" "$*" >> "$CALLS"; exit "${{{rc}}}"')
        for name, version in versions.items():
            package = self.npm_prefix / "lib/node_modules" / name
            package.mkdir(parents=True)
            command = name.rsplit("/", 1)[-1]
            (package / "package.json").write_text(json.dumps(
                {"name": name, "version": version, "bin": {command: "cli.js"}}))
            (package / "cli.js").write_text("// fixture command\n")
            (package / "cli.js").chmod(0o755)
            (self.npm_prefix / "bin" / command).symlink_to(package / "cli.js")
        return fragment

    def npm_package_json(self, name, value):
        import json
        (self.npm_prefix / "lib/node_modules" / name / "package.json").write_text(
            json.dumps(value))

    def npm_run(self, shell, fragment, upgrade=False):
        import json
        self.calls.unlink(missing_ok=True)
        self.npm_argv.unlink(missing_ok=True)
        self.npm_installed.unlink(missing_ok=True)
        output = self.run_shell(shell, '. "$1"; upgrade_mode=$3; . "$2"',
                                self.repo / "scripts/deploy.d/lib/helpers.zsh",
                                fragment, "true" if upgrade else "false")
        calls = [json.loads(line) for line in self.npm_argv.read_text().splitlines()]
        self.assertEqual(calls.count(["prefix", "-g"]), 1)
        self.assertEqual(calls.count(["ls", "-g", "--depth", "0", "--json"]), 1)
        # `rebuild -g` (46c89976, 2026-10-02) relinks bins before the inventory:
        # local and idempotent, so it belongs with the local-only operations.
        self.assertTrue(all(call[0] in ("prefix", "ls", "uninstall", "rebuild", "install")
                            for call in calls), "inventory must use only local npm queries")
        self.assertEqual([call for call in calls if call[0] == "rebuild"],
                         [["rebuild", "-g", *self.npm_specs]],
                         "bins must be relinked with the configured packages exactly once")
        # Parser/inventory/decision and batch/retry temp logs must be cleaned.
        for pattern in ("npm-inventory-parser.*", "npm-inventory.*",
                        "npm-decisions.*", "npm-global-batch.*", "npm-global.*"):
            self.assertEqual(list(self.base.glob(pattern)), [])
        installs = [call for call in calls if call[0] == "install"]
        survivors = ([json.loads(line) for line in self.npm_installed.read_text().splitlines()]
                     if self.npm_installed.exists() else [])
        return output, installs, survivors

    def npm_assert_batch(self, installs, specs):
        self.assertEqual(installs, [["install", "-g", "--libc=glibc", *specs]]
                         if specs else [])

    def test_npm_warm_latest_unversioned_and_binless_libraries_skip(self):
        versions = {"t3": "0.1.0", "@scope/tool": "2.0.0",
                    "happy-dom": "1.0.0", "@ast-grep/napi": "3.0.0"}
        fragment = self.npm_fixture(
            ["t3@latest", "@scope/tool", "happy-dom", "@ast-grep/napi@latest"], versions)
        for name in ("happy-dom", "@ast-grep/napi"):
            self.npm_package_json(name, {"version": versions[name]})
            (self.npm_prefix / "bin" / name.rsplit("/", 1)[-1]).unlink()
        for shell in SHELLS:
            with self.subTest(shell=shell):
                _, installs, survivors = self.npm_run(shell, fragment)
                self.npm_assert_batch(installs, [])
                self.assertEqual(survivors, [])

    def test_npm_missing_subset_and_empty_prefix_batch(self):
        specs = ["t3@latest", "@scope/tool", "oxlint"]
        fragment = self.npm_fixture(specs, {"t3": "0.1.0", "oxlint": "1.0.0"})
        for empty in (False, True):
            if empty:
                self.inventory.write_text('{"dependencies":{}}')
                shutil.rmtree(self.npm_prefix / "lib")
            for shell in SHELLS:
                with self.subTest(shell=shell, empty=empty):
                    _, installs, survivors = self.npm_run(shell, fragment)
                    expected = specs if empty else ["@scope/tool"]
                    self.npm_assert_batch(installs, expected)
                    self.assertEqual(survivors, expected)

    def test_npm_exact_pins_and_upgrade_channel_boundaries(self):
        specs = ["t3@latest", "@scope/tool", "plain", "oxlint@1.2.3",
                 "@scope/pinned@2.3.4-beta.1", "drift@1.2.3"]
        fragment = self.npm_fixture(specs, {"t3": "0.1.0", "@scope/tool": "0.1.0",
            "plain": "0.1.0", "oxlint": "1.2.3",
            "@scope/pinned": "2.3.4-beta.1", "drift": "1.2.2"})
        for upgrade in (False, True):
            for shell in SHELLS:
                with self.subTest(shell=shell, upgrade=upgrade):
                    _, installs, survivors = self.npm_run(shell, fragment, upgrade)
                    expected = (["t3@latest", "@scope/tool@latest", "plain@latest"]
                                if upgrade else [])
                    expected += ["drift@1.2.3"]
                    self.npm_assert_batch(installs, expected)
                    self.assertEqual(survivors, expected)

    def test_npm_failed_inventory_valid_stdout_and_garbage_are_conservative(self):
        specs = ["t3@latest", "@scope/tool@1.2.3"]
        fragment = self.npm_fixture(specs, {"t3": "0.1.0", "@scope/tool": "1.2.3"})
        for mode in ("fail", "garbage"):
            self.env["NPM_INVENTORY_MODE"] = mode
            for shell in SHELLS:
                with self.subTest(shell=shell, mode=mode):
                    _, installs, survivors = self.npm_run(shell, fragment)
                    self.npm_assert_batch(installs, specs)
                    self.assertEqual(survivors, specs)

    def test_npm_uncertain_installed_selectors_are_reinstalled_verbatim(self):
        specs = ["t3@beta", "@scope/tool@^2.0.0", "oxlint@latest"]
        fragment = self.npm_fixture(specs, {"t3": "1.0.0", "@scope/tool": "2.0.0",
                                           "oxlint": "1.0.0"})
        for shell in SHELLS:
            with self.subTest(shell=shell):
                _, installs, survivors = self.npm_run(shell, fragment)
                self.npm_assert_batch(installs, specs[:2])
                self.assertEqual(survivors, specs[:2])

    def test_npm_broken_integrity_exact_pin_probes_and_dedup(self):
        specs = ["t3@1.2.3", "@earendil-works/pi-coding-agent@2.0.0", "oxlint"]
        versions = {"t3": "1.2.3", "@earendil-works/pi-coding-agent": "2.0.0",
                    "oxlint": "1.0.0"}
        fragment = self.npm_fixture(specs, versions)
        for defect in ("dangling-bin", "unreadable-json", "nonstring-version",
                       "t3-probe", "pi-probe", "bin-and-probe"):
            for shell in SHELLS:
                with self.subTest(shell=shell, defect=defect):
                    package = self.npm_prefix / "lib/node_modules/t3"
                    self.npm_package_json("t3", {"version": "1.2.3", "bin": {"t3": "cli.js"}})
                    (package / "cli.js").write_text("// healthy fixture\n")
                    (package / "cli.js").chmod(0o755)
                    self.env.update(T3_PROBE_RC="0", PI_PROBE_RC="0")
                    if defect in ("dangling-bin", "bin-and-probe"):
                        (package / "cli.js").unlink()
                    if defect == "unreadable-json":
                        (package / "package.json").unlink()
                    if defect == "nonstring-version":
                        self.npm_package_json("t3", {"version": 123})
                    if defect in ("t3-probe", "bin-and-probe"):
                        self.env["T3_PROBE_RC"] = "1"
                    if defect == "pi-probe":
                        self.env["PI_PROBE_RC"] = "1"
                    _, installs, survivors = self.npm_run(shell, fragment)
                    expected = [specs[1] if defect == "pi-probe" else specs[0]]
                    self.npm_assert_batch(installs, expected)
                    self.assertEqual(survivors, expected)

    def test_npm_undeclared_broken_cli_warns_without_install(self):
        fragment = self.npm_fixture(["oxlint"], {"oxlint": "1.0.0"})
        self.env.update(T3_PROBE_RC="1", PI_PROBE_RC="1")
        for shell in SHELLS:
            with self.subTest(shell=shell):
                output, installs, _ = self.npm_run(shell, fragment)
                self.npm_assert_batch(installs, [])
                self.assertIn("WARNING: t3", output)
                self.assertIn("WARNING: pi", output)
                self.assertIn("not declared", output)

    def test_npm_batch_failure_retries_only_unsatisfied_and_preserves_survivors(self):
        specs = ["t3@latest", "@scope/bad@latest", "oxlint"]
        fragment = self.npm_fixture(specs, {"t3": "0.1.0"})
        self.env["NPM_FAIL_SPEC"] = "@scope/bad@latest"
        for shell in SHELLS:
            with self.subTest(shell=shell):
                output, installs, survivors = self.npm_run(shell, fragment)
                pending = specs[1:]
                self.assertEqual(installs,
                    [["install", "-g", "--libc=glibc", *pending]] +
                    [["install", "-g", "--libc=glibc", spec] for spec in pending])
                self.assertEqual(survivors, ["oxlint"])
                self.assertIn("@scope/bad@latest failed", output)
                self.assertIn("synthetic npm failure for @scope/bad@latest", output)
                self.assertIn("package(s) failed: @scope/bad@latest", output)

    def npm_extract_parser(self):
        # Extract literal production JS via its documented marker seam.
        extracted = subprocess.check_output(["sed", "-n",
            "/npm-inventory-parser BEGIN/,/npm-inventory-parser END/p",
            str(ROOT / "scripts/deploy.d/70_runtime_installs.zsh")], text=True)
        parser = self.base / "parser.js"
        parser.write_text("\n".join(extracted.splitlines()[1:-1]) + "\n")
        return parser

    def test_npm_bins_require_executable_regular_targets(self):
        spec = "tool@1.2.3"
        fragment = self.npm_fixture([spec], {"tool": "1.2.3"})
        parser = self.npm_extract_parser()
        target = self.npm_prefix / "lib/node_modules/tool/cli.js"
        # Keep the prefix/bin symlink present throughout. Only its target
        # changes, so mere link existence cannot satisfy these assertions.
        for kind, verdict in (("healthy-0755", "satisfied"),
                              ("nonexec-0644", "broken"),
                              ("directory", "broken"),
                              ("dangling", "broken")):
            if target.is_dir():
                target.rmdir()
            else:
                target.unlink(missing_ok=True)
            if kind == "directory":
                target.mkdir(mode=0o755)
            elif kind != "dangling":
                target.write_text("#!/bin/sh\nexit 0\n")
                target.chmod(0o755 if kind == "healthy-0755" else 0o644)
            with self.subTest(parser_target=kind):
                result = subprocess.run([str(self.bin / "node"), str(parser),
                    str(self.inventory), str(self.npm_prefix), spec],
                    text=True, capture_output=True, timeout=10)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stdout.split(), [spec, "tool", "1.2.3", verdict])
            for shell in SHELLS:
                with self.subTest(shell=shell, target=kind):
                    _, installs, survivors = self.npm_run(shell, fragment)
                    expected = [] if verdict == "satisfied" else [spec]
                    self.npm_assert_batch(installs, expected)
                    self.assertEqual(survivors, expected)

    def test_npm_real_inventory_parser_verdicts_and_selector_classes(self):
        specs = ["t3@latest", "t3@1.2.3-beta.1", "t3@1.2.3-beta.2", "missing",
                 "@scope/tool", "@scope/tool@2.0.0", "@scope/tool@2.0.1",
                 "happy-dom", "@ast-grep/napi@latest", "broken@1.2.3"]
        specs += ["t3@" + selector for selector in ("next", "beta", "^1.2.3", "~1", ">1", "*")]
        self.npm_fixture(specs, {"t3": "1.2.3-beta.1", "@scope/tool": "2.0.0",
            "happy-dom": "1.0.0", "@ast-grep/napi": "3.0.0", "broken": "1.2.3"})
        for name in ("happy-dom", "@ast-grep/napi"):
            self.npm_package_json(name, {"version": "1.0.0"})
        (self.npm_prefix / "bin/broken").unlink()
        parser = self.npm_extract_parser()
        result = subprocess.run([str(self.bin / "node"), str(parser),
            str(self.inventory), str(self.npm_prefix), *specs],
            text=True, capture_output=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        rows = [line.split() for line in result.stdout.splitlines()]
        self.assertTrue(all(len(row) == 4 for row in rows), result.stdout)
        self.assertEqual([row[0] for row in rows], specs)
        expected = ["satisfied", "satisfied", "pinmismatch", "missing",
                    "satisfied", "satisfied", "pinmismatch", "satisfied",
                    "satisfied", "broken"] + ["uncertain"] * 6
        self.assertEqual([row[3] for row in rows], expected)
        self.assertEqual(rows[3], ["missing", "missing", "-", "missing"])
        self.assertEqual(rows[4][1:3], ["@scope/tool", "2.0.0"])
        self.assertFalse(self.npm_argv.exists(), "standalone parser must never invoke npm")

    # ── Pluto fork runtime ────────────────────────────────────────────────

    def fork_fixture(self, cli="0.9.1", daemon="0.9.1-fork.1",
                     package="@camerontaylor/paseo-cli"):
        self.copy("scripts/deploy.d/lib/helpers.zsh")
        checker = self.copy("scripts/tests/check-paseo-pins.py")
        (self.bin / "python3").symlink_to(sys.executable)
        self.fake_mise()
        self.fake("paseo", 'printf "paseo %s\\n" "$*" >> "$CALLS"; '
                           'echo fixture-fork; exit "${PASEO_VERSION_RC:-0}"')
        infra = self.base / "infra with spaces"
        (infra / "nixos/hosts").mkdir(parents=True)
        (self.repo / "configs").mkdir()
        self.cli_declaration = self.repo / "configs/mise.toml"
        self.cli_declaration.write_text(
            '[tools]\n"npm:@getpaseo/cli" = '
            f'{{version="{cli}", os=["linux"]}}\n')
        self.daemon_declaration = infra / "nixos/hosts/pluto.nix"
        self.daemon_declaration.write_text(
            'systemd.services.paseo-daemon = { serviceConfig = {\n'
            f'ExecStart = "/fixture/mise exec npm:{package}@{daemon} -- "\n'
            '+ "paseo daemon run --home /fixture/home";\n}; };\n')
        self.marker = self.base / "synthetic NIXOS"
        self.marker.touch()
        self.env.update(INFRA_DIR=str(infra), FAKE_HOST="pluto.example.test",
                        NIXOS_FIXTURE_MARKER=str(self.marker))
        self.xdg_with_spaces()

        # Portable seam: run the CURRENT production host/runtime block, not
        # a Python reimplementation. Only its literal /etc/NIXOS operand is
        # redirected to a disposable file. Never create /etc/NIXOS or change
        # the hostname gate, checker, ref transformation, or mise operations.
        # Isolating the block excludes unrelated npm mise exec calls, so a
        # rejected checker can assert zero install/exec calls unambiguously.
        source = (ROOT / "scripts/deploy.d/70_runtime_installs.zsh").read_text()
        start = source.index("paseo_host=$(uname -n")
        end = source.index("\nunset paseo_host", start) + len("\nunset paseo_host")
        block = source[start:end]
        self.assertEqual(block.count("/etc/NIXOS"), 1,
                         "update the documented fixture seam if the host gate changes")
        block = block.replace("/etc/NIXOS", '"$NIXOS_FIXTURE_MARKER"')
        fragment = self.repo / "fork-runtime-fixture.zsh"
        fragment.write_text(block + "\n")
        return fragment, checker

    def run_fork(self, shell, fragment):
        self.calls.unlink(missing_ok=True)
        self.mise_args.unlink(missing_ok=True)
        return self.run_shell(shell, '. "$1"; upgrade_mode=false; . "$2"',
                              self.repo / "scripts/deploy.d/lib/helpers.zsh", fragment)

    def test_pluto_valid_pins_install_exact_scoped_selector_then_exec_plain_ref(self):
        fragment, _ = self.fork_fixture(cli="2.4.6", daemon="2.4.6-fork.7")
        ref = "npm:@camerontaylor/paseo-cli@2.4.6-fork.7"
        stock_shim = self.home / ".local/bin/paseo"
        stock_shim.parent.mkdir(parents=True)
        stock_shim.write_text("synthetic stock shim; must survive\n")
        declarations = (self.cli_declaration.read_bytes(),
                        self.daemon_declaration.read_bytes())
        for shell in SHELLS:
            with self.subTest(shell=shell):
                output = self.run_fork(shell, fragment)
                self.assertEqual(self.log().splitlines(), [
                    "mise install npm:@camerontaylor/paseo-cli"
                    "[allow_low_downloads=true]@2.4.6-fork.7",
                    f"mise exec {ref} -- paseo --version", "paseo --version"])
                self.assertEqual(self.mise_args.read_bytes(), (
                    "install\0npm:@camerontaylor/paseo-cli"
                    "[allow_low_downloads=true]@2.4.6-fork.7\0\n"
                    f"exec\0{ref}\0--\0paseo\0--version\0\n").encode())
                self.assertIn("fixture-fork", output,
                              "mise exec must actually run the version probe")
                self.assertEqual(declarations, (self.cli_declaration.read_bytes(),
                                               self.daemon_declaration.read_bytes()))
                self.assertEqual(stock_shim.read_text(),
                                 "synthetic stock shim; must survive\n")
                self.assertFalse((self.home / ".config/mise").exists())
                self.assertFalse((Path(self.env["XDG_STATE_HOME"]) /
                                  "paseo-fork-install.log").exists())

    def test_pluto_failed_checker_with_valid_looking_stdout_never_calls_mise(self):
        fragment, checker = self.fork_fixture()
        # Exercise the subprocess exit-status boundary, including partial
        # output that could trick a caller trusting stdout alone.
        checker.write_text('import sys\n'
                           'print("npm:@camerontaylor/paseo-cli@0.9.1-fork.1")\n'
                           'print("synthetic checker rejection", file=sys.stderr)\n'
                           'sys.exit(1)\n')
        for shell in SHELLS:
            with self.subTest(shell=shell):
                output = self.run_fork(shell, fragment)
                self.assertEqual(self.log(), "")
                self.assertIn("synthetic checker rejection", output)
                self.assertIn("NOT materialized", output)
                self.assertFalse(Path(self.env["XDG_STATE_HOME"]).exists())

    def test_pluto_real_checker_rejects_pin_mismatch_and_wrong_role(self):
        fragment, _ = self.fork_fixture()
        valid = self.daemon_declaration.read_text()
        for invalid, diagnostic in (
            (valid.replace("0.9.1-fork.1", "0.9.2-fork.1"), "mismatch"),
            (valid.replace("@camerontaylor/paseo-cli", "@getpaseo/cli"), "daemon role"),
        ):
            self.daemon_declaration.write_text(invalid)
            for shell in SHELLS:
                with self.subTest(shell=shell, diagnostic=diagnostic):
                    output = self.run_fork(shell, fragment)
                    self.assertEqual(self.log(), "")
                    self.assertIn(diagnostic, output)
                    self.assertIn("NOT materialized", output)
                    self.assertFalse(Path(self.env["XDG_STATE_HOME"]).exists())

    def test_pluto_missing_infra_warns_without_install(self):
        fragment, _ = self.fork_fixture()
        self.env["INFRA_DIR"] = str(self.base / "absent infra")
        for shell in SHELLS:
            with self.subTest(shell=shell):
                output = self.run_fork(shell, fragment)
                self.assertIn("missing", output)
                self.assertEqual(self.log(), "")
                self.assertFalse(Path(self.env["INFRA_DIR"]).exists())
                self.assertFalse(Path(self.env["XDG_STATE_HOME"]).exists())

    def test_fork_runtime_skips_other_nixos_hosts_and_non_nixos_pluto(self):
        fragment, checker = self.fork_fixture()
        # Make an accidental checker invocation observable, even if mise is
        # subsequently skipped. Valid declarations alone would hide it.
        checker.write_text('import os\nfrom pathlib import Path\n'
                           'Path(os.environ["CALLS"]).write_text("unexpected checker\\n")\n'
                           'raise SystemExit(1)\n')
        for host, nixos in (("ceres.example.test", True), ("pluto", False)):
            self.env["FAKE_HOST"] = host
            if not nixos:
                self.marker.unlink()
            for shell in SHELLS:
                with self.subTest(shell=shell, host=host, nixos=nixos):
                    self.assertEqual(self.run_fork(shell, fragment), "")
                    self.assertEqual(self.log(), "")
                    self.assertFalse(Path(self.env["XDG_STATE_HOME"]).exists())

    def test_pluto_install_failure_keeps_diagnostics_and_never_executes_fork(self):
        fragment, _ = self.fork_fixture()
        self.env["MISE_INSTALL_RC"] = "17"
        for shell in SHELLS:
            with self.subTest(shell=shell):
                output = self.run_fork(shell, fragment)
                self.assertEqual(self.log().splitlines(), [
                    "mise install npm:@camerontaylor/paseo-cli"
                    "[allow_low_downloads=true]@0.9.1-fork.1"])
                self.assertIn("synthetic install failure", output)
                self.assertIn("WARNING", output)
                log = Path(self.env["XDG_STATE_HOME"]) / "paseo-fork-install.log"
                self.assertIn("synthetic install failure", log.read_text())

    def test_runtime_dry_run_never_calls_installers(self):
        self.copy("scripts/deploy.d/lib/helpers.zsh")
        fragment = self.copy("scripts/deploy.d/70_runtime_installs.zsh")
        self.fake_mise()
        self.env["DEPLOY_DRY_RUN"] = "1"
        before = list(self.home.rglob("*"))
        for shell in SHELLS:
            with self.subTest(shell=shell):
                self.calls.unlink(missing_ok=True)
                self.run_shell(shell, '. "$1"; upgrade_mode=true; . "$2"',
                               self.repo / "scripts/deploy.d/lib/helpers.zsh", fragment)
                self.assertEqual(self.log(), "")
                self.assertEqual(list(self.home.rglob("*")), before)

    def test_karabiner_dry_run_never_executes_bun_or_changes_config(self):
        self.copy("scripts/deploy.d/lib/helpers.zsh")
        fragment = self.copy("scripts/deploy.d/78_karabiner.zsh")
        source = self.repo / "configs/karabiner/karabiner.ts"
        source.parent.mkdir(parents=True)
        source.write_text("// synthetic generator input; never executed\n")
        config_home = self.home / "configuration with spaces"
        target = config_home / "karabiner/karabiner.json"
        self.env.update(DOTFILES_OS="Darwin", DEPLOY_DRY_RUN="1",
                        XDG_CONFIG_HOME=str(config_home))
        # If the production dry-run guard regresses, this fake generator both
        # records the call and writes only inside our disposable HOME. No real
        # bun or macOS configuration tools are reachable through this fixture.
        self.fake("bun", 'printf "bun %s\\n" "$*" >> "$CALLS"; '
                         'mkdir -p "$XDG_CONFIG_HOME/karabiner"; '
                         'echo unexpected-generation > "$XDG_CONFIG_HOME/karabiner/karabiner.json"')
        for existing in (False, True):
            for shell in SHELLS:
                with self.subTest(shell=shell, existing=existing):
                    if config_home.exists():
                        shutil.rmtree(config_home)
                    if existing:
                        target.parent.mkdir(parents=True)
                        target.write_text('{"synthetic": "live GUI preference"}\n')
                        target.with_suffix(".json.bak").write_text("prior backup\n")
                        # Force the normal regeneration condition, so skipping
                        # bun cannot be explained by an up-to-date target.
                        os.utime(target, (100, 100))
                        os.utime(source, (200, 200))
                    before = {p.relative_to(self.home): p.read_bytes() if p.is_file() else None
                              for p in self.home.rglob("*")}
                    self.calls.unlink(missing_ok=True)
                    self.run_shell(shell, '. "$1"; upgrade_mode=false; . "$2"',
                                   self.repo / "scripts/deploy.d/lib/helpers.zsh", fragment)
                    self.assertEqual(self.log(), "", "dry-run executed the TypeScript runtime")
                    self.assertEqual(before, {
                        p.relative_to(self.home): p.read_bytes() if p.is_file() else None
                        for p in self.home.rglob("*")})

    # ── pinned plugin submodules ──────────────────────────────────────────

    def plugin_fixture(self):
        self.repo = self.base / "plugin repo with spaces"
        self.env["SCRIPT_DIR"] = str(self.repo)
        self.copy("scripts/deploy.d/lib/helpers.zsh")
        fragment = self.copy("scripts/deploy.d/30_plugins.zsh")
        (self.repo / "zsh/plugins").mkdir(parents=True)
        pin = "a" * 40
        plugin = self.repo / "plugins/fixture"
        (self.repo / "plugins.lock").write_text(
            f"{pin} plugins/fixture https://invalid.example/fixture.git\n")
        self.env.update(PLUGIN_PIN=pin, SUBMODULE_RC="0")
        # A minimal repository boundary: HEAD is stored in a file, cloning
        # materializes a synthetic tree, checkout changes HEAD. Submodule
        # content is independent of the parent HEAD, just like real gitlinks.
        self.fake("git", '''printf "git %s\\n" "$*" >> "$CALLS"
repo=.
if [ "$1" = -C ]; then repo=$2; shift 2; fi
case "$1" in
    rev-parse)
        [ -f "$repo/.fixture-head" ] || exit 1
        case "$2" in
            HEAD) cat "$repo/.fixture-head";;
            --git-dir) echo .git;;
            *) exit 97;;
        esac
        ;;
    clone)
        for target do :; done
        mkdir -p "$target"
        echo cloned-head > "$target/.fixture-head"
        echo '[submodule "fixture-dependency"]' > "$target/.gitmodules"
        ;;
    fetch) :;;
    checkout)
        for revision do :; done
        printf '%s\\n' "$revision" > "$repo/.fixture-head"
        ;;
    submodule)
        [ "$SUBMODULE_RC" = 0 ] || exit "$SUBMODULE_RC"
        echo materialized > "$repo/.fixture-submodules"
        ;;
    *) exit 96;;
esac''')
        return fragment, plugin, pin

    def run_plugin(self, shell, fragment):
        self.calls.unlink(missing_ok=True)
        return self.run_shell(shell, '. "$1"; upgrade_mode=false; . "$2"',
                              self.repo / "scripts/deploy.d/lib/helpers.zsh", fragment)

    def test_plugin_at_pin_still_materializes_missing_submodules(self):
        fragment, plugin, pin = self.plugin_fixture()
        plugin.mkdir(parents=True)
        (plugin / ".fixture-head").write_text(pin + "\n")
        (plugin / ".gitmodules").write_text('[submodule "fixture-dependency"]\n')
        for shell in SHELLS:
            with self.subTest(shell=shell):
                (plugin / ".fixture-submodules").unlink(missing_ok=True)
                self.run_plugin(shell, fragment)
                self.assertEqual(self.log().splitlines(), [
                    f"git -C {plugin} rev-parse HEAD",
                    f"git -C {plugin} submodule update --init --recursive --quiet"])
                self.assertEqual((plugin / ".fixture-submodules").read_text(), "materialized\n")

    def test_plugin_new_clone_and_off_pin_both_update_submodules(self):
        fragment, plugin, pin = self.plugin_fixture()
        for state in ("missing", "off-pin"):
            for shell in SHELLS:
                with self.subTest(shell=shell, state=state):
                    if plugin.exists():
                        shutil.rmtree(plugin)
                    if state == "off-pin":
                        plugin.mkdir(parents=True)
                        (plugin / ".fixture-head").write_text("b" * 40 + "\n")
                        (plugin / ".gitmodules").write_text('[submodule "fixture-dependency"]\n')
                    self.run_plugin(shell, fragment)
                    calls = self.log().splitlines()
                    checkout = f"git -C {plugin} checkout --quiet --detach {pin}"
                    submodule = f"git -C {plugin} submodule update --init --recursive --quiet"
                    self.assertIn(checkout, calls)
                    self.assertIn(submodule, calls)
                    self.assertLess(calls.index(checkout), calls.index(submodule))
                    self.assertEqual(any(line.startswith("git clone ") for line in calls),
                                     state == "missing")
                    self.assertEqual((plugin / ".fixture-head").read_text(), pin + "\n")
                    self.assertEqual((plugin / ".fixture-submodules").read_text(), "materialized\n")

    def test_plugin_dry_run_never_updates_submodules_or_checkouts(self):
        fragment, plugin, pin = self.plugin_fixture()
        self.env["DEPLOY_DRY_RUN"] = "1"
        for state in ("at-pin", "off-pin", "missing"):
            for shell in SHELLS:
                with self.subTest(shell=shell, state=state):
                    if plugin.exists():
                        shutil.rmtree(plugin)
                    if state != "missing":
                        plugin.mkdir(parents=True)
                        (plugin / ".fixture-head").write_text(pin if state == "at-pin" else "b" * 40)
                        (plugin / ".gitmodules").write_text('[submodule "fixture-dependency"]\n')
                    before = {p.relative_to(self.repo): p.read_bytes()
                              for p in self.repo.rglob("*") if p.is_file()}
                    self.run_plugin(shell, fragment)
                    self.assertTrue(all(line.endswith("rev-parse HEAD")
                                        for line in self.log().splitlines()))
                    self.assertEqual(before, {p.relative_to(self.repo): p.read_bytes()
                                              for p in self.repo.rglob("*") if p.is_file()})
                    self.assertEqual(plugin.exists(), state != "missing")

    def test_plugin_submodule_failure_warns_and_deploy_continues(self):
        fragment, plugin, pin = self.plugin_fixture()
        plugin.mkdir(parents=True)
        (plugin / ".fixture-head").write_text(pin + "\n")
        (plugin / ".gitmodules").write_text('[submodule "fixture-dependency"]\n')
        self.env["SUBMODULE_RC"] = "19"
        for shell in SHELLS:
            with self.subTest(shell=shell):
                output = self.run_plugin(shell, fragment)
                self.assertIn("WARNING: submodule sync failed", output)
                self.assertIn("plugins/fixture", output)
                self.assertFalse((plugin / ".fixture-submodules").exists())


if __name__ == "__main__":
    unittest.main()
