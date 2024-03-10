function! NavigateToPreviousWindows()
    execute ":edit /Users/eric/vim/autocomplete/java_auto_complete.vim"
    execute ":vsplit /Users/eric/vim/debugger/vim_debugger.vim"
endfun

nnoremap <leader>whr :call NavigateToPreviousWindows()<cr>
