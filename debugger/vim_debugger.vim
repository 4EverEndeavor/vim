let g:currentLine = ''
let g:db_chan = ''
let g:db_job = ''
let g:popup_window_id = ''
let g:term_buf = ''

" nnoremap <leader>dc :call CheckVimFileForErrorsAndNavigateToProblemLine()<cr>
nnoremap <leader>d :call DebugVimFile()<cr>
" nnoremap <leader>d :call RunVimDebugger()<cr>

function! CheckFunctionErrors(start_line, stop_line)
    let l:lines = []
    for line_number in range(a:start_line, a:stop_line)
        let l:lines = add(l:lines, getline(line_number))
    endfor
    echom "lines: " . string(l:lines)

    let l:code = filter(copy(l:lines), 'v:val =~ "^\\s*\\w"')

    for command in l:code
        let l:response = input("execute command? : " . command)
        if l:response ==# "y"
            execute command
        endif
    endfor

endfunction

" TODO make a check for any function that doesnt have (). It's a real pain in that ass.
function! CheckVimFileForErrorsAndNavigateToProblemLine()
    " make sure none of these 
    :%s/function/function/g

    " just quote everything to start
    :%s/^//g

    let l:prev_start = 0
    while 1
        let l:start = search("^\function")
        if l:start < l:prev_start
            echo "start is earlier"
            break
        else
            echo "prev is now start"
            let l:prev_start = l:start
        endif
        let l:stop = search("^\endfunc")
        
        echom "start: " . l:start
        echom "stop: " . l:stop
        for i in range(start, stop)
            let line_text = getline(i)
            let new_text = substitute(line_text, '', '', 'g')
            call setline(i, new_text)
        endfor

        write

        redir @e
        source %
        redir END
        let result = getreg(@e)

        echo "result: " . string(result)

        if result ==# ''
            echom "Error in method between lines " . l:start . ':' . l:stop
            break
        endif

        call input("Written and sourced file successfully")
    endwhile

    :%s///g
    
    execute 'call cursor('.prev_start.',1)'
    " call CheckFunctionErrors(prev_start, l:stop))

endfunc

function! CopyDbScriptToDebug()
    let filename = expand('%:t')
    let fullpath = expand('%:p:h')
    echom "old path: " . fullpath
    echom "old name: " . filename
    " the new file name has a fucking space in the front!!!
    let destination_file = substitute(filename, '.vim', '_debug.vim', "")
    echom "new_file " . destination_file
    let source_contents = readfile(source_file)
    " execute ":w! " . fullpath . '/' destination_file
    " call append(0, source_contents)
endfunction

function! AddDebuggerLines()
    let l:inside_func = 0
    let l:func_end_matcher = "endfunc.*"
    let l:lines = readfile(expand('%:p'))
    let l:line_num = 0
    for line in l:lines
        let l:line_num += 1
        if line =~ '^function! \w\+(.*)$'
            let l:inside_func = 1
        elseif line =~ '^endfunc.*$'
            let l:inside_func = 0
        elseif line =~ '^\s\+" .*$'
            " ingnore comment lines
            continue
        elseif l:inside_func
            execute "normal! " . l:line_num . "G"
            execute "normal! A | call DB(" . l:line_num . ", execute(\":let l:\"))"
        endif
    endfor
endfunc

function! RemoveDebuggerLines()
    :%s/ | call DB([0-9]\+\, execute(\":let l:\"))//g
endfunc

function! DB(line_number, local_vars)
    let g:debugger_variables['local vars'] = deepcopy(a:local_vars)
    " call UpdateDebuggerVariableWindow()
    " call UpdateCurrentWindow()
    let l:next_line_number = a:line_number
    echom "moving cursor to line: " . l:next_line_number
    " execute "normal! " . l:next_line_number . "G"
    execute "normal! " . a:local_vars . "G"
    let l:response = input(a:line_number . '> ' . getline(a:line_number) . ': ')
    if l:response != 'n'
        execute l:response
    endif
endfunc

function! RunVimDebugger()
    echom "running debugger"
    let output = execute(":debug call Test_CompleteJava()")
    echom "local vars: " . output
    :breakadd func Test_CompleteJava 85
    :breakadd func CompleteJava 61
endfunc

function! CreateDebuggerVarsPopup(channel, vars)
    :call popup_clear(1)
    let l:options = {'line':"cursor-1"}
    let l:options['col'] = "cursor"
    let g:popup_window_id = popup_create(a:vars, l:options)
endfunc

let g:debugger_variables = {'local vars': {}, 'global vars': {}}
let g:current_win = winnr()
let g:debugger_var_win = -1

function! CreateDebuggerVariableWindow()
    " Save the current window and cursor positions
    let g:current_win = winnr()
    let current_cursor = getpos('.')

    " Open a new vertical split on the right side
    vsplit debugger_vars

    " Make the right window read-only
    " setlocal readonly

    " grab new window num
    echom "Setting debugger window number: ". winnr()
    let g:debugger_var_win = winnr()

    " navigate back to previous window
    execute g:current_win . 'wincmd w'
    call setpos('.', current_cursor)
endfunction

function! DeleteDebuggerVariableWindow()
    " save current position
    let current_cursor = getpos('.')

    " move to debug_vars window
    echom "Closing window id: " . g:debugger_var_win
    execute g:debugger_var_win . 'wincmd w'

    " close the window
    execute ":q!"

    " go back to original position
    call setpos('.', current_cursor)
endfunction

function! UpdateDebuggerVariableWindow()
    " save current place
    let current_cursor = getpos('.')

    " move to debug_vars window
    echom "moving to window: " . g:debugger_var_win
    execute g:debugger_var_win . 'wincmd w'

    " Clear the right window and display the updated dictionary
    execute 'normal! ggVGd'
    let dict_str = string(g:debugger_variables)
    call append(0, split(dict_str, '\n'))
    echom "redrawing debug window: " . winnr()
    :checktime
    redraw " Force var screen update

endfunction

function! UpdateCurrentWindow()
    " Move the focus back to the left window
    execute g:current_win . 'wincmd w'
    call setpos('.', current_cursor)

    " refresh original window
    echom "redrawing original window: " . winnr()
    :checktime
    redraw " Force debug screen update
endfunction

" Autocommand to trigger the update when the buffer is written
" autocmd BufWritePost * call UpdateAndRefresh()


" DEBUG MODE
function! Step()
    :call SendKeys("step\<cr>")
    :call UpdatePosition()
    :call GetAllLocalVarNames()
endfunc

function! Next()
    :call SendKeys("next\<cr>")
    :call UpdatePosition()
    :call GetAllLocalVarNames()
endfunc

function! Continue()
    :call SendKeys("cont\<cr>")
    :call UpdatePosition()
    :call GetAllLocalVarNames()
endfunc

function! QuitDebugger()
    :call term_sendkeys(g:term_buf, "q\<cr>")
    :call term_sendkeys(g:term_buf, ":q\<CR>")
    :call UnSetDebugMode()
    :call popup_clear(1)
endfunc

" Define a breakpoint sign
sign define myBreakpoint text=●
function! SetBreakPoint()
    let l:ln = line('.')
    execute ":sign place " . l:ln . " line=".l:ln . " name=myBreakpoint"
    let l:funcName = ParseGotoName()
    let l:funcLine = search("^function! " . l:funcName, "n")
    let l:breakLine = l:ln - l:funcLine
    :call SendKeys("breakadd func " . l:breakLine . " " . ParseGotoName() . "\<cr>")
endfunc

function! RemoveBreakPoint()
    let l:ln = line('.')
    :call SendKeys("breakdel *\<cr>")
    execute "sign unplace " . l:ln
endfunction

function! Finish()
    :call UnSetDebugMode()
    :call SendKeys("finish\<cr>")
endfunction
" END DEBUG MODE

function! ParseGotoName()
    let l:numLines = line('$', bufwinid(g:term_buf))
    for l:ln in range(l:numLines, 1, -1)
        let l:termLine = term_getline(g:term_buf, l:ln)
        if l:termLine =~ "^function "
            return matchlist(l:termLine, "\\(\[a-zA-Z_]\\+\\)$")[1]
        endif
    endfor
endfunc

function! ParseGotoLine()
    let l:numLines = line('$', bufwinid(g:term_buf))
    for l:ln in range(l:numLines, 1, -1)
        let l:termLine = term_getline(g:term_buf, l:ln)
        if l:termLine =~ "^line "
            return matchlist(l:termLine, "^line\\s\\+\\([0-9]\\+\\):")[1]
        endif
    endfor
endfunc

function! UpdatePosition()
    let l:goToName = ParseGotoName()
    let l:goToLine = ParseGotoLine()
    let l:goToFile = FindFileForFunc(l:goToName)
    if l:goToFile != expand('%:p')
        let l:goToFile = substitute(l:goToFile, '\r', '', 'g')
        for i in range(len(l:goToFile))
            echom char2nr(l:goToFile[i]) . ' '
        endfor
        let l:viewCmd = "view " . l:goToFile
        execute l:viewCmd
    endif
    let l:funcLineBegins = search("^function! " . l:goToName)
    call cursor(l:funcLineBegins + l:goToLine, 0)
endfunc

function! FindFileForFunc(funcName)
    for l:scriptObj in getscriptinfo()
        let l:sid = l:scriptObj.sid
        let l:functions = getscriptinfo({'sid':l:sid})['functions']['functions']
        if index(l:functions, a:funcName) != -1
            return l:scriptObj['name']
        endif
    endfor
    echoerr "no file found for func name: " . a:funcName
endfunction

function! DbCallback(channel, message)
    echom "prompt: " . a:message

    let l:funcName = ''
    let l:funcMatch = matchlist(a:message, "function \\(\\a\\+\\)")
    if !empty(l:funcMatch)
        let l:funcName = l:funcMatch[1]
    endif

    let l:lineNumber = ''
    let l:lineMatch = matchlist(a:message, "line \\([0-9]\\+\\)")
    if !empty(l:lineMatch)
        let l:lineNumber = l:lineMatch[1]
    endif

    let l:funcFile = ''
    if !empty(l:funcName)
        let l:funcFile = FindFileForFunc(l:funcName)
    endif

    if !empty(l:funcFile) && !empty(l:funcName) && !empty(l:lineNumber)
        " call input('INPUT: ' . l:funcName . ' : ' . l:lineNumber . ' : ' . l:funcFile)
        if l:funcFile != expand('%:p')
            " call input("moving to file: " . l:funcFile)
            let l:funcFile = substitute(l:funcFile, '\r', '', 'g')
            for i in range(len(l:funcFile))
                echom char2nr(l:funcFile[i]) . ' '
            endfor
            let l:viewCmd = "view " . l:funcFile
            " call input("type: " . type(l:funcFile))
            " call input("Command: " . l:viewCmd)
            execute l:viewCmd
            " :view l:funcFile
        endif
        execute "normal! /^function! " . l:funcName . "\<cr>"
        execute "normal! " . l:lineNumber . "j"
        let g:currentLine = line('.')
    endif
endfunc

function! DebugSelf(debuggeeCommand)
    call SetDebugMode()
    let g:currentLine = line('.')
    :let l:currentFile = expand('%:p')
    " :let g:db_job = job_start("vim -R " . l:currentFile, {'mode':'raw', 'callback':'DbCallback'})
    :let g:db_job = job_start("vim -R " . l:currentFile, {'mode':'raw'})
    :let g:db_chan = job_getchannel(g:db_job)
    :call ch_logfile("/Users/eric/vim/debugger/db_log.txt", 'w')
    :call ch_sendraw(g:db_chan, ":" . a:debuggeeCommand . "\<cr>")
    " :call ch_sendexpr(g:db_chan, ":" . a:debuggeeCommand . "\<cr>")
endfunc

function! DebugTerm(debuggeeCommand)
    let g:currentLine = line('.')
    let l:currentFile = expand('%:p')
    let l:window = winnr()
    vs /Users/eric/vim/debugger/db_output.json
    :set autoread
    let g:term_buf = term_start("vim", {'term_rows':20})
    " get number of lines in terminal buffer
    " let l:numLines = line('$', bufwinid(g:term_buf))
    call term_sendkeys(g:term_buf, ":" . a:debuggeeCommand . "\<cr>")
    execute l:window . 'wincmd w'

    call SetDebugMode()
endfunc

function! GetAllLocalVarNames()
    call term_sendkeys(g:term_buf, "let l:varDict = {}\<cr>")
    call term_wait(g:term_buf, 100)
    let l:varNames = GetAllVariableMentionsInFunction()
    for l:varName in l:varNames
        call term_sendkeys(g:term_buf, "let l:varDict[\"" . l:varName . "\"] = " . l:varName . "\<cr>")
        call term_wait(g:term_buf, 100)
    endfor
    call term_sendkeys(g:term_buf, "let l:json = json_encode(l:varDict)\<cr>")
    call term_wait(g:term_buf, 100)
    call term_sendkeys(g:term_buf, "call writefile([l:json], \"/Users/eric/vim/debugger/db_output.json\")\<cr>")
    call term_wait(g:term_buf, 100)
endfunc

function! ParseVariableJson(l_var_list)
    let l_vars = {}

    " Process the list and populate the dictionary
    for line in split(a:l_var_list, "\n")
      " Skip empty lines
      if line =~ '^\s*$'
        continue
      endif

      " Extract variable name and value
      let parts = split(line, '=')
      let var_name = substitute(trim(parts[0]), 'l:', '', '')
      let var_value = trim(parts[1])

      " Add the variable to the dictionary
      let l_vars[var_name] = var_value
    endfor

    " Display the content of the l_vars dictionary
    echo l_vars
endfunc

function! GetAllVariableMentionsInFunction()
    " TODO for loop variables
    let l:startLine = search("^function", "bn")
    let l:varNames = []
    for l:ln in range(l:startLine, line('.')-1)
        let l:line = getline(l:ln)
        if l:line =~ "\\s\\+let \[a-zA-Z_:]\\+ ="  
            let l:varName = split(split(l:line, '=')[0], 'let')[1][1:-2]
            let l:varNames += [l:varName]
        endif
    endfor
    let l:signature = getline(l:startLine)
    let l:ml = matchlist(l:signature, "(\\(.*\\))")
    if l:ml[1] != ''
        let l:params = split(l:ml[1], ', ')
        call map(l:params, "'a:' . v:val")
        let l:varNames += l:params
    endif
    
    return ListToSet(l:varNames)
endfunc

function! SendKeys(keys)
    call term_sendkeys(g:term_buf, a:keys)
    call term_wait(g:term_buf, 100)
endfunc
