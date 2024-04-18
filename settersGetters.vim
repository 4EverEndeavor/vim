function! s:GenerateSetter(name, type)
    let l:Name = substitute(a:name, '\(\w\)\(\w*\)', '\u\1\2', '')
    let l:setter = ["    public void set" . l:Name . "(" . a:type . ' ' . a:name . ")"]
    let l:setter += ["    {"]
    let l:setter += ["        _" . a:name . " = " . a:name . ";"]
    let l:setter += ["    }"]
    return l:setter
endfunc

function! s:GenerateGetter(name, type)
    let l:Name = substitute(a:name, '\(\w\)\(\w*\)', '\u\1\2', '')
    let l:getter = ["    public " . a:type . " get" . l:Name . "()"]
    let l:getter += ["    {"]
    let l:getter += ["        return _" . a:name . ";"]
    let l:getter += ["    }"]
    return l:getter
endfunc

function! s:GenerateSettersAndGetters() range
    let l:start = line("'<")
    let l:stop = line("'>")
    let l:setGetList = ['']
    for l:ln in range(l:start, l:stop)
        let l:splt = split(getline(l:ln), ' ')
        let l:name = l:splt[-1][1:-2]
        let l:type = l:splt[-2]
        let l:setGetList += s:GenerateGetter(l:name, l:type)
        let l:setGetList += s:GenerateSetter(l:name, l:type)
    endfor
    call append(line('$') - 1, l:setGetList)
endfunc

xnoremap ms :<c-u>call <sid>GenerateSettersAndGetters()<cr>
