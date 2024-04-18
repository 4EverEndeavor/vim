" autocmd FileOpen 

function FoldJavaClass()

execute 'normal! ' . l:start . 'Gzf' . l:stop . 'G'

