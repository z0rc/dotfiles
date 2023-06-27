augroup filetypedetect
    au! BufRead,BufNewFile *.gotmpl setlocal filetype=gohtmltmpl
    au! BufRead,BufNewFile *.yaml.gotmpl setlocal filetype=yaml.gohtmltmpl
augroup END
