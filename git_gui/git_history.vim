" make a utility to pull git logs,
" enter a commit by clicking
" see git history of selection

function! s:ShowGitHistoryForSelection() range
    let l:command = "git log -L " . line("'<") . "," . line("'>") . ":" . expand("%:p")
    echom "something"
    echom l:command
    let git_job = term_start(l:command, {"vertical":1})
endfunc

xnoremap mh :<c-u>call <sid>ShowGitHistoryForSelection()<cr>
