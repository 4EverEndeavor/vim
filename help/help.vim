nnoremap <leader>h :set operatorfunc=<SID>HelpOperator<cr>g@
vnoremap <leader>h :<c-u>call <SID>HelpOperator(visualmode())<cr>

function! s:HelpOperator(type)
    let saved_unnamed_register = @@

	if a:type ==# 'v'
		execute "normal! `<v`>y"
	elseif a:type ==# 'char'
		execute "normal! `[y`]"
	else
		return
	endif

	execute ":help " . getreg('@@')

	let @@ = saved_unnamed_register
endfunc
