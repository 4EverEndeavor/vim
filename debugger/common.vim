function! SetDebugMode()
    echom "Entering Debug Mode"
    :set cursorline
    let g:saved_mappings['s'] = maparg('s')
    nnoremap s :call Step()<cr>
    let g:saved_mappings['n'] = maparg('n')
    nnoremap n :call Next()<cr>
    let g:saved_mappings['c'] = maparg('c')
    nnoremap c :call Continue()<cr>
    let g:saved_mappings['q'] = maparg('q')
    nnoremap q :call QuitDebugger()<cr>
    let g:saved_mappings['b'] = maparg('b')
    nnoremap b :call SetBreakPoint()<cr>
    let g:saved_mappings['r'] = maparg('r')
    nnoremap r :call RemoveBreakPoint()<cr>
    let g:saved_mappings['f'] = maparg('f')
    nnoremap f :call Finish()<cr>
endfunction

function! UnSetDebugMode()
    echom "Exiting Debug Mode"
    :set nocursorline
    if exists('g:saved_mappings')
        if has_key(g:saved_mappings, 's')
            if empty(g:saved_mappings['s'])
                execute 'unmap s'
            else
                execute 'nnoremap ' . g:saved_mappings['s']
            endif
        endif
    endif
    if exists('g:saved_mappings')
        if has_key(g:saved_mappings, 'n')
            if empty(g:saved_mappings['n'])
                execute 'unmap n'
            else
                execute 'nnoremap ' . g:saved_mappings['n']
            endif
        endif
    endif
    if exists('g:saved_mappings')
        if has_key(g:saved_mappings, 'c')
            if empty(g:saved_mappings['c'])
                execute 'unmap c'
            else
                execute 'nnoremap ' . g:saved_mappings['c']
            endif
        endif
    endif
    if exists('g:saved_mappings')
        if has_key(g:saved_mappings, 'q')
            if empty(g:saved_mappings['q'])
                execute 'unmap q'
            else
                execute 'nnoremap ' . g:saved_mappings['q']
            endif
        endif
    endif
    if exists('g:saved_mappings')
        if has_key(g:saved_mappings, 'b')
            if empty(g:saved_mappings['b'])
                execute 'unmap b'
            else
                execute 'nnoremap ' . g:saved_mappings['b']
            endif
        endif
    endif
    if exists('g:saved_mappings')
        if has_key(g:saved_mappings, 'r')
            if empty(g:saved_mappings['r'])
                execute 'unmap r'
            else
                execute 'nnoremap ' . g:saved_mappings['r']
            endif
        endif
    endif
    if exists('g:saved_mappings')
        if has_key(g:saved_mappings, 'f')
            if empty(g:saved_mappings['f'])
                execute 'unmap f'
            else
                execute 'nnoremap ' . g:saved_mappings['f']
            endif
        endif
    endif
endfunction
