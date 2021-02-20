import subprocess
from ranger.api.commands import Command


class z(Command):
    def execute(self):
        directory = subprocess.check_output(
            ["zsh", "-ic", "z -e " + self.arg(1)],
            text=True
        ).rstrip("\n")
        self.fm.cd(directory)
