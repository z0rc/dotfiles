import subprocess
import re
from ranger.api.commands import Command


class z(Command):
    def execute(self):
        directory_with_ansi = subprocess.run(
            ['zsh', '-ic', 'z -e ' + self.arg(1)],
            capture_output=True,
            text=True
        ).stdout

        # cleanup:
        # - ansi codes used by iterm's shell integration
        # - newlines
        directory = re.sub(r'(\x1b.*\x07|\n)', '', directory_with_ansi)
        self.fm.cd(directory)
