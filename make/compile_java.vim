autocmd Filetype java set makeprg=javac\ %
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
map <F9> :make<Return>:copen<Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>

function! CompileJava()
	if g:machine == "workMacbook"
		call GradleCompileJava()
	elseif g:machine == "alpineXps"
		call CompilePlainJava()
	endif
endfunc

function! GradleCompileJava()
    " set makeprg=gradle\ compileJava\ $*
    set makeprg=gradle\ compileJava\ testClasses\ $*
    execute ":silent make -p " . FindGradleHome() . "\<cr>"
    execute ":copen"
    execute "normal! /\\(error\\|BUILD SUCCESSFUL\\)"
endfunc

function! CompilePlainJava()
	set makeprg=/root/factorize/java/compileJava.sh
	:cd /root/factorize/java
	execute ":silent! make\<cr>"
	:copen
	:cd -
endfunc

nnoremap <leader>b :silent call CompileJava()<cr>
