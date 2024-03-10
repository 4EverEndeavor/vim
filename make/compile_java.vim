autocmd Filetype java set makeprg=javac\ %
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
map <F9> :make<Return>:copen<Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>

function! GradleCompileJava()
    set makeprg=gradle\ compileJava\ $*
    execute ":make -p " . FindGradleHome()
    execute ":copen"
endfunc

nnoremap <leader>b :silent call GradleCompileJava()<cr>
