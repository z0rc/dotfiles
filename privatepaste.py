#!/usr/bin/env python
# vim: sw=4 ts=4 expandtab smarttab
"""
Private Paste Command Line Utility
privatepaste.com

@author Adrian <adrian@planetcoding.net>
@since  2010-04-11
"""

import urllib, httplib, optparse, os.path, re, sys

languages = [
    'ActionScript','AppleScript','Apache','Bash','BBCode','Boo','C','Clojure','CSS',
    'C++','C#','Delphi','Diff','Erlang','Fortran','Haskell','HTML','INI','IRC','Java',
    'JavaScript','JSP','Lighttpd','LUA','Makefile','Matlab','NASM','Nginx','Objective C',
    'OCaml','Pascal','Perl','PHP','Python','Rst','Ruby','Scheme','Smalltalk','Smarty',
    'Squid','SQL','TeX','TCL','Wiki','VBNet','VimL','XML','XSLT','YAML'
]

modifiers = {
    's': 1,
    'seconds': 1,
    'm': 60,
    'minutes': 60,
    'h': 3600,
    'hours': 3600,
    'd': 24*3600,
    'days': 24*3600,
    'w': 7*24*3600,
    'weeks': 7*24*3600,
    'M': 30*24*3600,
    'months': 30*24*3600,
    'y': 365*24*3600,
    'years': 365*24*3600
}


def chunks(seq, size):
    return (seq[pos:pos + size] for pos in xrange(0, len(seq), size))


def parse_duration(duration_str):
    duration = 0
    tokens = re.findall(r'\d+|\w+', duration_str)
    for pair in chunks(tokens, 2):
        if len(pair) == 1:
            pair.append('seconds')

        try:
            val = int(pair[0])
        except ValueError:
            print >>sys.stderr, 'Unexpected modifier: %s' % pair[0]
            continue

        mod = pair[1]

        if len(mod) > 1:
            mod = mod.lower()

        if len(mod) > 1 and mod[-1] != 's':
            mod += 's'

        if mod not in modifiers:
            print >>sys.stderr, 'Invalid modifier: %s' % pair[1]
            continue

        duration += val * modifiers[mod]

    return duration


def privatepaste(content, formatting=None, line_numbers=False, expires='1 month', password=None):
    params = urllib.urlencode([
        ('paste_content', content),
        ('formatting', formatting or 'No Formatting'),
        ('line_numbers', 'on' if line_numbers else 'off'),
        ('expire', parse_duration(expires)),
        ('secure_paste', 'on' if password else 'off'),
        ('secure_paste_key', password or ''),
    ])

    headers = {'Content-type': 'application/x-www-form-urlencoded'}
    host = 'privatepaste.com'

    print >>sys.stderr, 'Pasting...'
    conn = httplib.HTTPSConnection(host)
    conn.request('POST', '/save', params, headers)
    response = conn.getresponse()
    key = response.getheader('Location')
    if not key:
        return 'Pasting failed - was your paste empty?'

    conn.close()
    return 'https://' + host + key


parser = optparse.OptionParser()

parser.add_option('-l', '--lang', dest='language', default=None,
                  type='choice', choices=languages,
                  help='Specify the language for syntax highlighting')
parser.add_option('-e', '--expiration', dest='expiration', default='1 month',
                  help="Duration after which the paste expires; e.g. '1 week 3 hours'")
parser.add_option('-p', '--password', dest='password', default=None,
                  help='Encrypt paste with the given password.')
parser.add_option('-n', '--line-numbers', action='store_true', dest='line_numbers', default=False,
                  help='Display line numbers in paste')
parser.add_option('-L', '--list-languages', action='store_true', dest='list_languages', default=False,
                  help='Display the list of supported languages')
parser.add_option('-t', '--tee', action='store_true', dest='tee', default=False,
                  help='Display everything read from stdin on stdout (ignored if both stdin and stdout are ttys)')
parser.add_option('--no-tee', action='store_true', dest='no_tee', default=False,
                  help='Do not imply --tee when stdout is not a tty.')
parser.add_option('-D', '--savedefaults', action='store_true', dest='save_defaults', default=False,
                  help='Save the given arguments except --tee/--no-tee as defaults in ~/.config/privatepasterc')
parser.add_option('--irc', dest='language',
                  action='store_const', const='IRC',
                  help='Shortcut for --lang IRC (IRC log highlighting)')


options, args = parser.parse_args()

# Display language list if requested
if options.list_languages:
    print 'Supported languages:'
    for langs in chunks(languages, 10):
        print '  %s' % ', '.join(langs)
    sys.exit(0)

if options.tee and options.no_tee:
    print >>sys.stderr, 'The options --tee and --no-tee are mutually exclusive'
    sys.exit(1)

config_file = os.path.expanduser('~/.config/privatepasterc')
if options.save_defaults:
    with open(config_file, 'w') as f:
        if options.language:
            f.write('LANGUAGE=%s\n' % options.language)
        if options.expiration:
            f.write('EXPIRATION=%s\n' % options.expiration)
        if options.password:
            f.write('PASSWORD=%s\n' % options.password)
        if options.line_numbers:
            f.write('LINE_NUMBERS=True\n')

    print 'Options have been saved to ~/.config/privatepasterc'
    sys.exit(0)

if os.path.isfile(config_file):
    with open(config_file, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            key, val = line.split('=', 1)
            if key in ['LANGUAGE', 'EXPIRATION', 'PASSWORD', 'LINE_NUMBERS']:
                setattr(options, key.lower(), val)

# Parse options again since commandline args have higher priority than defaults.
options, args = parser.parse_args(None, options)

if not options.tee and not options.no_tee and not sys.stdout.isatty():
    print >>sys.stderr, 'Output is not a TTY; implying --tee.'
    options.tee = True

if options.tee and sys.stdin.isatty() and sys.stdout.isatty():
    print >>sys.stderr, 'Both stdin and stdout are ttys; ignoring --tee.'
    options.tee = False

if sys.stdin.isatty():
    print >>sys.stderr, 'Enter the text you want to paste and press CTRL+D when finished.'

content = ''
while 1:
    line = sys.stdin.readline()
    if line == '':
        break
    content += line
    if options.tee:
        sys.stdout.write(line)

link = privatepaste(content.rstrip(), formatting=options.language, line_numbers=options.line_numbers,
                    expires=options.expiration, password=options.password)
print >>sys.stderr, link

