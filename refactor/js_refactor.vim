function! GetFuncsForTemplate(template)
    let l:template_lines = readfile(a:template)
    let l:funcsInTemplate = []
    for l:line in l:template_lines
        let l:funcMatch = matchstr(l:line, "\\a\\+(")[:-2]
        echom l:funcMatch
        if !empty(l:funcMatch) && index(l:funcsInTemplate, l:funcMatch) == -1
            let l:funcsInTemplate += [l:funcMatch]
        endif
    endfor
    return l:funcsInTemplate
endfunc

function! CalledByTheseOtherFuncs(source, funcName)
    " Use match() instead
    let l:sourceLines = readfile(a:source)
    let l:prevFunc = ""
    let l:otherFuncs = []
    for l:line in l:sourceLines
        if l:line =~ "^function "
            let l:prevFunc = split(l:line[9:], '(')[0]
        elseif l:line =~ "\\(function \\)\\{0}" . a:funcName . "("
            let l:otherFuncs += [l:prevFunc]
        endif
    endfor
    let l:otherFuncs = ListToSet(l:otherFuncs)
    return l:otherFuncs
endfunc

function! CallsTheseOtherFuncs(source, funcName)
    " find where the func line starts
    let l:funcStart = 0
    let l:lines = readfile(a:source)
    for l:lnum in range(len(l:lines))
        let l:line = l:lines[l:lnum]
        if l:line =~ "^function " . a:funcName . "(.*)"
            let l:funcStart = l:lnum + 1 " stupid 1 indexing
            break
        endif
    endfor

    let l:level = 0
    let l:funcStr = ''
    let l:foundEnd = 0
    for l in range(l:funcStart - 1, len(l:lines))
        let l:line = l:lines[l]
        for c in l:line
            if c ==# '{'
                let l:level += 1
            elseif c ==# '}'
                let l:level -= 1
                if l:level == 0
                    let l:foundEnd = 1
                    break
                endif
            else
                let l:funcStr .= c
            endif
        endfor
        if l:foundEnd | break | endif
    endfor
    let l:otherFuncs = Matches(l:funcStr, ' \a\+(')
    call map(l:otherFuncs, 'v:val["value"]')
    call map(l:otherFuncs, 'v:val[1:-2]')
    let l:otherFuncs = ListToSet(l:otherFuncs)
    return l:otherFuncs
endfunc

function! FuncCalledByOtherTemplate(funcName)
    let l:templatePath = "/Users/eric/Rhombus/rhombus-cloud-admin/src/main/resources/templates"
    let l:command = 'grep -lrR --exclude="*.swp" '
    let l:results = systemlist(l:command . a:funcName . ' ' . l:templatePath)
    if len(l:results) > 1
        echom "[" . a:funcName . "] called by other templates: " . string(l:results)
        return 1
    else
        return 0
    endif
endfunc

function! CanRefactor(source, funcName)
    " termination condition:
    if FuncCalledByOtherTemplate(a:funcName)
        return 0
    endif
    let l:calledByOtherFuncs = CalledByTheseOtherFuncs(a:source, a:funcName)
    let l:calledByOthers = Sum(map(l:calledByOtherFuncs, "CanRefactor(a:source, v:val)"))
    let l:callsOthers = Sum(map(CallsTheseOtherFuncs(a:source, a:funcName), "CanRefactor(a:source, v:val)"))
    " Called elsewhere in the code, like outside of a function
    return l:calledByOthers + l:callsOthers == 0
endfunc

function! Refactor(template, source, target)
    let l:template_funcs = GetFuncsForTemplate(a:template)
    for l:template_func in l:template_funcs
        if CanRefactor(a:source, l:template_func)
            MoveFuncToTarget(l:template_func, a:target)
        endif
    endfor
endfunc

function! TestRefactor()
    :debug call Refactor("/Users/eric/Rhombus/rhombus-cloud-admin/src/main/resources/templates/views/internal/pages/hardware.html","/Users/eric/Rhombus/rhombus-cloud-admin/src/main/resources/static/internal.js", "/Users/eric/Rhombus/rhombus-cloud-admin/src/main/resources/static/pages/hardware.js")
endfunc
