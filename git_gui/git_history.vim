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

function! GitStatus()
    let l:project_root = fnamemodify(systemlist('git rev-parse --show-toplevel')[0], ':p')
    execute 'cd ' l:project_root
    let git_job = term_start("git status")
endfunc

function! s:GitAdd()
    for l:ln in range(line("'<"), line("'>"))
        let l:add = split(getline(l:ln), "\\s\\+")[-1]
        call system("git add " . l:add)
    endfor
endfunc

xnoremap ma :<c-u>call <sid>GitAdd()<cr>
