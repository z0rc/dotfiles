import subprocess
from ranger.api.commands import Command


class z(Command):
    def execute(self):
        directory = subprocess.check_output(["zsh", "-ic", "z -e " + self.arg(1)])
        directory = directory.decode("utf-8", "ignore").rstrip('\n')
        self.fm.execute_console("cd " + directory)
