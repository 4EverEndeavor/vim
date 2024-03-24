let g:saved_mappings = {}

function! SetDebugMode()
    :set cursorline
    let g:saved_mappings['s'] = maparg('s')
    nnoremap s :call Step()<cr>
    let g:saved_mappings['n'] = maparg('n')
    nnoremap n :call Next()<cr>
    let g:saved_mappings['c'] = maparg('c', 'n')
    nnoremap c :call Continue()<cr>
    let g:saved_mappings['q'] = maparg('q')
    nnoremap q :call QuitDebugger()<cr>
    let g:saved_mappings['b'] = maparg('b')
    nnoremap b :call SetBreakPoint()<cr>
    let g:saved_mappings['r'] = maparg('r')
    nnoremap r :call RemoveBreakPoint()<cr>
    let g:saved_mappings['f'] = maparg('f')
    nnoremap f :call Finish()<cr>
    let g:saved_mappings['q'] = maparg('q')
    nnoremap f :call Quit()<cr>
endfunction

function! UnSetDebugMode()
    :set nocursorline
    unmap s
    unmap b
    unmap r
    unmap n
    unmap q
    unmap f
    if exists('g:saved_mappings')
        if has_key(g:saved_mappings, 'c')
            execute ":nnoremap c " . g:saved_mappings['c']
        endif
    endif
endfunction
