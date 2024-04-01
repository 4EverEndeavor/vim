function! ConvertFunctions()
    let l:ln = search('^\s\+def [a-zA-Z()\, ]\+:', 'n')
    if l:ln > 0
        let l:ml = matchlist(getline(l:ln), '^\(\s\+\)def \([a-zA-Z()\, ]\+\):')
        echom l:ml
    endif
endfunc

function! TabsToSpaces()
    :%s/	/    /g
endfunc

function! ConvertPythonFileToJava()
    call ConvertFunctions()
endfunc
