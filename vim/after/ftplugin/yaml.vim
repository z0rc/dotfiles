setlocal tabstop=2 shiftwidth=2 softtabstop=2

" disable lsp diagnostics for helmfile.yaml, as it isn't a real yaml file
if expand('<afile>') =~ "helmfile"
    let g:lsp_diagnostics_enabled=0
endif
