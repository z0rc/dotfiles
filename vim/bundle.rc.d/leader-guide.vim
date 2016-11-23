" define prefix dictionary
let g:lmap={}

" git menu
let g:lmap.g={
              \'name' : 'Git',
              \'s' : ['Gstatus', 'Status'],
              \'p' : ['Gpull',   'Pull'],
              \'u' : ['Gpush',   'Push'],
              \'c' : ['Gcommit', 'Commit'],
              \'w' : ['Gwrite',  'Write']
              \}

" gitgutter hunks menu
let g:lmap.g.h={
                \'name' : 'Hunks',
                \'p' : ['call feedkeys("\<Plug>GitGutterPreviewHunk")', 'Preview'],
                \'u' : ['call feedkeys("\<Plug>GitGutterUndoHunk")', 'Undo'],
                \'s' : ['call feedkeys("\<Plug>GitGutterStageHunk")', 'Stage']
                \}

" nerdcommenter menu
let g:lmap.c={
              \'name' : 'Comments',
              \' ' : ['call feedkeys("\<Plug>NERDCommenterToggle")', 'Toggle'],
              \'$' : ['call feedkeys("\<Plug>NERDCommenterToEOL")', 'From cursor to EOL'],
              \'a' : ['call feedkeys("\<Plug>NERDCommenterAltDelims")', 'Switch to alternate delimiters'],
              \'A' : ['call feedkeys("\<Plug>NERDCommenterAppend")', 'Add comment at EOL'],
              \'b' : ['call feedkeys("\<Plug>NERDCommenterAlignBoth")', 'Aligned both sides'],
              \'c' : ['call feedkeys("\<Plug>NERDCommenterComment")', 'Comment'],
              \'i' : ['call feedkeys("\<Plug>NERDCommenterInvert")', 'Toggle selected line(s)'],
              \'l' : ['call feedkeys("\<Plug>NERDCommenterAlignLeft")', 'Aligned left side'],
              \'m' : ['call feedkeys("\<Plug>NERDCommenterMinimal")', 'Minimal'],
              \'n' : ['call feedkeys("\<Plug>NERDCommenterNested")', 'Nested'],
              \'s' : ['call feedkeys("\<Plug>NERDCommenterSexy")', 'Sexy'],
              \'u' : ['call feedkeys("\<Plug>NERDCommenterUncomment")', 'Uncomment'],
              \'y' : ['call feedkeys("\<Plug>NERDCommenterYank")', 'Yank & comment']
              \}

" test menu
let g:lmap.t={
              \'name' : 'Test',
              \'t' : ['TestNearest', 'Nearest'],
              \'T' : ['TestFile', 'This file'],
              \'a' : ['TestSuite', 'All'],
              \'l' : ['TestLast', 'Last'],
              \'g' : ['TestVisit', 'Open test file']
              \}

" toggles
let g:lmap.T={
              \'name' : 'Toggles',
              \'l' : ['LToggle', 'Location list'],
              \'q' : ['QToggle', 'Quickfix window'],
              \'N' : ['NERDTreeToggle', 'NERDTree'],
              \'t' : ['TagbarToggle', 'Tagbar'],
              \'n' : ['NumbersToggle', 'Numbers'],
              \}

" searches
let g:lmap.a=['Ag', 'ag search']
if has('mac')
    let g:lmap.d=['Dash', 'Dash search']
endif

call leaderGuide#register_prefix_descriptions("\\", "g:lmap")
nnoremap <silent> <leader> :<c-u>LeaderGuide '<leader>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<leader>'<CR>
