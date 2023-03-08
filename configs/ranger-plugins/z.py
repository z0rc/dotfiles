import subprocess
import re
from ranger.api.commands import Command


class z(Command):
    # cleanup ansi codes returned by iterm's shell integration
    clean_iterm_ansi = re.compile(r'\x1b.*\x07')

    def execute(self):
        directory_with_ansi = subprocess.run(
            ['zsh', '-ic', f'z -e {self.arg(1)}'],
            capture_output=True,
            text=True
        ).stdout

        directory = self.clean_iterm_ansi.sub(
            '', directory_with_ansi
        ).rstrip('\n')
        self.fm.cd(directory)

    def tab(self, tabnum):
        directories_with_ansi = subprocess.run(
            ['zsh', '-ic', f'z --complete {self.arg(1)}'],
            capture_output=True,
            text=True
        ).stdout

        directories = self.clean_iterm_ansi.sub(
            '', directories_with_ansi
        ).splitlines()
        return [f'z {directory}' for directory in directories]
