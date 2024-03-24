function! RefreshIndexes()
    let l:r_job = job_start('find ~/ -type f -regex ".*\.java$" > /Users/eric/.vim_indexes/java_file_index', {'mode':'raw', 'exit_cb':'RefreshJavaFileIndexComplete'})
    let l:c_job = job_start('find ~/ -type f -regex ".*\.class$" > /Users/eric/.vim_indexes/java_class_index', {'mode':'raw', 'exit_cb':'RefreshJavaClassIndexComplete'})
endfunc

function! RefreshJavaFileIndexComplete(job, status)
    echom "Java files have been refreshed status: " . a:status
endfunc

function! RefreshJavaClassIndexComplete(job, status)
    echom "Java classes have been refreshed: " . a:status
endfunc
