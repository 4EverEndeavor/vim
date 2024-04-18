let s:postCmd = ''
let s:sequence = 1

function! GetInjectedString()
    let l:injLn = search("@InjectMocks", 'n')
    let l:injLine = getline(l:injLn + 1)
    return split(split(getline(15), '=')[0], ' ')[-1]
endfunc

function! GenerateMocksForMethod()
    let l:funcStr = GetInjectedString()
    let l:ln = search(l:funcStr, 'n')
    let l:ml = matchlist(getline(l:ln), "= " . l:funcStr . '.\(\a\+\)(')
    echom l:ml
endfunc

function! NextTag()
    " call input("sequence number: " . s:sequence)
    let l:next = search("#" . s:sequence . ":.*#")
    echom l:next
    if l:next ==# 0
        echom "done!"
        let s:sequence = 1
        return 0
    endif
    let l:ml = matchlist(getline('.'), s:sequence . ":\\(\[^#]*\\)#", col('.'))
    if empty(l:ml[1])
        echoerr "no command found"
    endif
    let s:sequence += 1
    let l:command = ml[1]
    " delete tag text
    execute "normal! dt#x" 
    if l:command ==# "insert"
        autocmd InsertLeave * ++once call NextTag()
        call timer_start(50, {-> feedkeys("i", 'n')})
        return 0
    elseif l:command ==# "injected"
        autocmd InsertLeave * ++once call NextTag()
        call feedkeys("i" . GetInjectedString(), 'n')
        return 0
    elseif l:command ==# "mocks"
        call append(getline('.'), GenerateMocksForMethod())
    elseif l:command ==# "prev"
        execute "normal! \".p"
    endif
endfunc

function! ShowTemplateFiles()
    let file_list = systemlist("ls /Users/eric/vim/templates/*.java")
    let choice = inputlist(map(copy(file_list), 'v:key . ". " . fnamemodify(v:val, ":t")'))
    if choice >= 0
        let file_content = readfile(file_list[choice])
        call append(line('.'), file_content)
        call NextTag()
    endif
endfunction

nnoremap <F4> :call ShowTemplateFiles()<CR>
