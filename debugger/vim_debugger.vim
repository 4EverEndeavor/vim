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

let g:breakpoints = []
let g:in_break = 0
let g:continuing = 0

function! DebugVimFile()
    " this needs to be at the front, otherwise the cursor position changes
    let l:func_name = GetFunctionName()
    call AddDebuggerLines()
    call SetDebugMode()
    " call SetBreakPoint()
    call CreateDebuggerVariableWindow()
    :source %
    execute ":call " . l:func_name . "()"
    call UnSetDebugMode()
    call DeleteDebuggerVariableWindow()
    call RemoveDebuggerLines()
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

function! CreateDebuggerVarsPopup()
    let l:local_vars = ["Value Trunca..."]
    let l:options = {'line':146}
    let l:options['col'] = 11
    let l:popup_window_id = popup_create(l:local_vars, l:options)
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

function! Step()
    echom "step"
endfunc

function! Next()
    echom "next"
endfunc

function! Continue()
    echom "continue"
endfunc

function! QuitDebugger()
    echom "quit"
endfunc

" Define a breakpoint sign
sign define myBreakpoint text=●
function! SetBreakPoint()
    let l:ln = line('.')
    echom "Breakpoint set at: " . l:ln
    execute ":sign place " . l:ln . " line=".l:ln . " name=myBreakpoint"
    let g:breakpoints += [l:ln]
endfunc

function! RemoveBreakPoint()
    echom "removing break"
    let l:ln = line('.')
    let l:index = index(g:breakpoints, l:ln)
    if l:index != -1
        call remove(g:breakpoints, index)
    endif
    execute "sign unplace " . l:ln
endfunction

function! Finish()
    let g:continuing = 1
    let g:in_break = 0
    call UnSetDebugMode()
endfunction

let g:saved_mappings = {}



function! GetFunctionName()
    execute "normal! viwy"
    return @0
endfunction

function! OutHandler(channel, message)
    echom "message received: " . string(a:message)
endfunction
function! ErrHandler(channel, message)
    echom "message received: " . string(a:message)
endfunction

function! InitFE()
    :let channel = ch_open('localhost:8765')
    :call ch_sendexpr(channel, "{\"client\":\"frontend\"}")
endfunc

function! SendFE()
    :call ch_sendexpr(channel, "{\"to\":\"backend\", \"message\":\"Hello BE\"}")
endfunc

function! InitBE()
    :let channel = ch_open('localhost:8765')
    :call ch_sendexpr(channel, "{\"client\":\"backend\"}")
endfunc

function! SendBE()
    :call ch_sendexpr(channel, "{\"to\":\"frontend\", \"message\":\"Hello FE\"}")
endfunc

function! CloseS()
    :call ch_close(channel)
endfunc

let g:db_chan = ''
let g:db_job = ''

function! DebugSelf()
    :let g:job = job_start("vim -S start_back.vim test_debug_back.vim", {'mode':'raw'})
    :let g:db_chan = job_getchannel(job)
    :call ch_logfile(g:db_chan, "db_log.txt")
    :call ch_sendraw(g:db_chan, "breakadd func DummyFunk2 11")
    :call ch_sendraw(g:db_chan, "step")
    :call ch_sendraw(g:db_chan, "step")
    :call ch_sendraw(g:db_chan, "step")
    :call ch_sendraw(g:db_chan, "step")
    :call ch_sendraw(g:db_chan, "step")
    :call ch_sendraw(g:db_chan, "step")
endfunc

function! SendMessage()
    :call ch_sendexpr(channel, "breakadd func DummyFunk2 11")
    :call ch_evalexpr(channel, "['ex','breakadd func DummyFunk2 11']")
    :call ch_sendexpr(channel, "['ex','breaklist']")
endfunc

function! GetLocalVariableList()
    let l_vars = {}

    " Get the list of global variables
    let l_var_list = execute("redir => gvar_list | silent let g: | redir END")

    " Process the list and populate the dictionary
    for line in split(l_var_list, "\n")
      " Skip empty lines
      if line =~ '^\s*$'
        continue
      endif

      " Extract variable name and value
      let parts = split(line, '=')
      let var_name = substitute(trim(parts[0]), 'g:', '', '')
      let var_value = trim(parts[1])

      " Add the variable to the dictionary
      let l_vars[var_name] = var_value
    endfor

    " Display the content of the l_vars dictionary
    echo l_vars
endfunc
