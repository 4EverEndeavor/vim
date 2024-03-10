function! WriteVimDictToJsonFile(dict, file_name)
    let s:json = json_encode(a:dict)
    " let s:path = expand('%:p:h') . a:file_name
    call writefile([s:json], a:file_name)
endfunc

function! ReadVimDictFromJsonFile(filename)
    return json_decode(join(readfile(a:filename), "\n"))
endfunc

function! FindJavaPackageName()
    let l:saved_pos = getpos('.')
    let prev_reg = @0
    execute "normal! ggwvt;y"
    let package_name = @0
    let @0 = prev_reg
    call setpos('.', l:saved_pos)
    return package_name
endfunction

function! FindCurrentJavaTestMethodName()
    let l:saved_pos = getpos('.')
    let l:test_line = search("@Test", 'b')
    let l:line = getline(l:test_line + 1)
    let l:split = split(l:line, " ")
    let result = filter(l:split, 'v:val =~ ".*()"')[0]
    let result = result[:-3]
    call setpos('.', l:saved_pos)
    return result
endfunc

function! FindJavaClassName()
    let l:saved_pos = getpos('.')
    let filename = expand('%:t')
    let file_split = split(filename, "[.]")
    let class_name = file_split[0]
    call setpos('.', l:saved_pos)
    return class_name
endfunction

function! FindJavaContructorParameters()
    let prev_reg = @0
    let @/ = FindJavaClassName() . '('
    execute "normal! nelv%y"
    let parameters = @0
    let @0 = prev_reg
    let parameters = substitute(parameters, '\%x00', '', 'g')
    let parameters = substitute(parameters, '(', '', 'g')
    let parameters = substitute(parameters, ')', '', 'g')
    let parameters = split(parameters, ',')
    let parameters = map(parameters, 'trim(v:val)')
    return parameters
endfunction

" TODO use findfile going backwards for this.
function! FindGradleHome()
    let l:saved_directory = trim(execute('pwd'))
    let l:candidate = ""
    let l:retval = ""
    let l:directory_for_this_file = expand('%:p:h')
    execute ":cd " . l:directory_for_this_file
    for i in range(1,15)
        :cd ..
        let l:current_directory = trim(execute('pwd'))
        if l:current_directory ==# '/'
            echoerr "Unable to find gradle directory!"
            break
        endif
        if HasBuildGradle() && empty(l:candidate)
            " don't do anything yet, the directory above could have
            " the main build.gradle
            let l:candidate = l:current_directory
        elseif HasBuildGradle()
            " candidate is not empty, we went up one and found the main
            let l:retval = l:current_directory
            break
        elseif !empty(l:candidate)
            " the candidate was set, we went up and didn't find anything
            let l:retval = l:candidate
            break
        endif
    endfor
    execute ":cd " . l:saved_directory
    return l:retval
endfunc

function! HasBuildGradle()
    let l:current_files = split(system("ls"))
    for file_str in l:current_files
        if file_str ==# "build.gradle"
            return 1
        endif
    endfor
endfunc

function! GetFullyQualifiedTestMethodName()
    return GetFullyQualifiedClassName() . '.' . FindCurrentJavaTestMethodName()
endfunc

function! GetFullyQualifiedClassName()
    return FindJavaPackageName() . '.' . FindJavaClassName()
endfunc
