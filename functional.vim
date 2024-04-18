function! Sorted(l)
    let new_list = deepcopy(a:l)
    call sort(new_list)
    return new_list
endfunction

function! Reversed(l)
    let new_list = deepcopy(a:l)
    call reverse(new_list)
    return new_list
endfunction

function! Append(l, val)
    let new_list = deepcopy(a:l)
    call add(new_list, a:val)
    return new_list
endfunction

function! Assoc(l, i, val)
    let new_list = deepcopy(a:l)
    let new_list[a:i] = a:val
    return new_list
endfunction

function! Pop(l, i)
    let new_list = deepcopy(a:l)
    call remove(new_list, a:i)
    return new_list
endfunction

function! Mapped(fn, l)
    let new_list = deepcopy(a:l)
    call map(new_list, string(a:fn) . '(v:val)')
    return new_list
endfunction

function! Filtered(fn, l)
    let new_list = deepcopy(a:l)
    call filter(new_list, string(a:fn) . '(v:val)')
    return new_list
endfunction

function! Removed(fn, l)
    let new_list = deepcopy(a:l)
    call filter(new_list, '!' . string(a:fn) . '(v:val)')
    return new_list
endfunction

function! Sum(l)
    let l:total = 0
    for l:number in a:l
        let l:total += l:number
    endfor
    return l:total
endfunction

function! MatchesInList(list, pattern)
    let l:matches = []
    let l:start = 0
    while 1
        let l:match = matchstrpos(a:list, a:pattern, l:start)
        if l:match[0] ==# ""
            break
        endif
        let l:matchObj = {}
        let l:matchObj['value'] = l:match[0]
        let l:matchObj['index'] = l:match[1]
        let l:matchObj['left'] = l:match[2]
        let l:matchObj['right'] = l:match[3]
        call add(l:matches, l:matchObj)
        let l:start = l:matchObj['index'] + 1
    endwhile
    return l:matches
endfunction

function! MatchesInString(expr, pattern)
    let l:matches = []
    let l:start = 0
    while 1
        let l:match = matchstrpos(a:expr, a:pattern, l:start)
        if l:match[0] ==# ""
            break
        endif
        let l:matchObj = {}
        let l:matchObj['value'] = l:match[0]
        let l:matchObj['left'] = l:match[1]
        let l:matchObj['right'] = l:match[2]
        call add(l:matches, l:matchObj)
        let l:start = l:matchObj['right']
    endwhile
    return l:matches
endfunction

function! Matches(expr, pattern)
    if type(a:expr) ==# 1
        return MatchesInString(a:expr, a:pattern)
    elseif type(a:expr) ==# 3
        return MatchesInList(a:expr, a:pattern)
    else
        echoerr "unhandled match expression"
    endif
endfunction

function! ListToSet(list)
    let l:set = []
    for l:item in a:list
        if index(l:set, l:item) ==# -1
            let l:set += [l:item]
        endif
    endfor
    return l:set
endfunction
