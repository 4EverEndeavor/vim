function! RunJavaUnitTest()
    let filepath = expand('%:p')
    let filepath = substitute(filepath, '.*src', 'src', '')
    let g_command = "gradle -p " . FindGradleHome()
    let g_command .= " test --debug --tests " . GetFullyQualifiedTestMethodName()
    echom g_command

    let l:g_test_job = job_start(g_command, {"close_cb":"RunGradleBuildCallback"})
endfunc

function! RunGradleBuildCallback(channel)
    let l:output_lines = []
    while ch_status(a:channel, {'part': 'out'}) == 'buffered'
      let l:output_lines += [ch_read(a:channel)]
    endwhile
    echom "all done..."
    call writefile(l:output_lines, "test_output.txt")
    execute ":vsplit | view test_output.txt"
    execute "normal! <cr>"
endfunc
