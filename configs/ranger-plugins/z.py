import subprocess
from ranger.api.commands import Command


class z(Command):
    def execute(self):
        directory = subprocess.check_output(
            ["zsh", "-c", "z -e " + self.arg(1)]
        ).decode("utf-8").rstrip("\n")
        self.fm.cd(directory)
