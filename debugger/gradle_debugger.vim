" add the following to build.gradle
" bootRun if debugging remote server
" test {
"     jvmArgs '-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005'
" }
" try this next:
" compileJava.options.debugOptions.debugLevel = "source,lines,vars"
" compileTestJava.options.debugOptions.debugLevel = "source,lines,vars"

function! GradleDaemonFuckingStuckHandler(channel, msg)
    if stridx(a:msg, "Listening for transport dt_socket at address: 5005") != -1
        echom "Substring found in string"
        " gradle daemon is waiting now, reset jdb
        " call ReAttachJDB()
    endif
endfunc

function! JdbCallback(channel, msg)
    echom a:msg
endfunction

let g:jdb_jb = ''
let g:jdb_chan = ''
function! InitJDB()
    let g:jdb_jb = job_start("jdb -attach 5005", {'mode':'raw', 'callback':'JdbCallback'})
    let g:jdb_chan = job_getchannel(g:jdb_jb)
    call ch_logfile("jdb_ch_log.txt")
    call ch_sendraw(g:jdb_chan, "run")
endfunction

function! ReAttachJDB()
    call ch_sendraw(g:jdb_chan, "quit")
    call ch_sendraw(g:jdb_chan, "jdb -attach 5005")
    call ch_sendraw(g:jdb_chan, "stop at com.rhombus.cloud.webservice.controller.api.CameraWebserviceControllerTest:146")
    " call SetBreakpoints()
endfunc


function! RunGradleJDB()
    " start gradle daemon
    let l:command = "gradle -p " . FindGradleHome() . " "
    let l:command .= "clean test -Dorg.gradle.debug=true --no-daemon "
    let l:command .= "--no-build-cache --debug -Dtest.debug "
    let l:command .= "--tests " . GetFullyQualifiedTestMethodName()
    let l:options = {'term_rows':10, 'callback':'GradleDaemonFuckingStuckHandler'}
    echom l:command
    let l:term_b = term_start(l:command, l:options)
    wincmd p
endfunction
