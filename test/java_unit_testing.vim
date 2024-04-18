let s:t_popup = 0
function! RunJavaUnitTest()
    let filepath = expand('%:p')
    let filepath = substitute(filepath, '.*src', 'src', '')
    let g_command = "gradle -p " . FindGradleHome()
    let l:test_method_name = GetFullyQualifiedTestMethodName()
    let g_command .= " test --debug --tests " . l:test_method_name
    let l:pu_message = 'Running test: ' . l:test_method_name
    let s:t_popup = popup_create(l:pu_message, {'line': 1, 'col': 1, 'pos': 'topright'})
    let l:g_test_job = job_start(g_command, {"close_cb":"RunGradleBuildCallback"})
endfunc

function! RunGradleBuildCallback(channel)
    let l:output_lines = []
    while ch_status(a:channel, {'part': 'out'}) == 'buffered'
        " just filtering out all the timestamp and other stuff hogging up the page
        let l:ln_splt = split(ch_read(a:channel), ']')
        if len(l:ln_splt) == 1
            let l:output_lines += [l:ln_splt[0]]
        elseif len(l:ln_splt) > 1
            let l:output_lines += [l:ln_splt[-1]]
        endif
    endwhile
    call popup_close(s:t_popup)
    call writefile(l:output_lines, "test_output.txt")
    execute ":vsplit | view test_output.txt"
    :set nowrap
    " execute "%s/^.*\]//g\<cr>"
    call system("afplay /System/Library/Sounds/Glass.aiff")
    execute "normal! /\\(BUILD SUCCESSFUL\\|FAILED\\)\<cr>"
endfunc
