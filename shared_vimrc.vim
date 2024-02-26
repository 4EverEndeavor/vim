" Shared file that is updated via github

" Basic settings------------------ {{{
set relativenumber
set number
set foldlevel=0
set sw=4
set wrap
set tabstop=4
set hlsearch
set dictionary?
set dictionary+=/root/.vim/dictionary.txt
" }}}

nnoremap <space> viw

let mapleader = ","
let maplocalleader = "\\"

" Mappings---------------------- {{{
nnoremap <leader>ev :vsplit /root/vim/shared_vimrc.vim<cr>G
nnoremap <leader>sv :source $MYVIMRC<cr>

" easy mapping for esc
inoremap jk <esc>
inoremap <esc> <nop>

" tile navigation
nnoremap K <c-w><up>
nnoremap J <c-w><down>
nnoremap L <c-w><right>
nnoremap H <c-w><left>

" surround word with quotations
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
" }}}

" Abbreviations-----------------{{{
iabbrev adn and
iabbrev waht what
iabbrev tehn then
iabbrev @@ eric.berger48@gmail.com
iabbrev pulbic public
" }}}

augroup filetype_java:
    " clear auto commands
    autocmd!
    autocmd FileType java nnoremap <buffer> <localleader>c I//<esc>
augroup END

augroup filetype_python:
    autocmd!
    autocmd FileType python iabbrev <buffer> iff if:<left>
augroup END

" Vimscript file settings --------------------- {{{
augroup filetype_vim:
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" operator mappings, p maps to i-nside (-arenthesis
onoremap p i(
" map the operator to the first occurrence of return
onoremap b /return<cr>

" nnoremap <leader>g :silent execute "grep! -Iris " . shellescape(expand("<cWORD>")) . " ."<cr>:copen 15<cr>

" Plugins ---------------------------{{{
execute "source /root/vim/plugins/fold-column.vim"
"-----------------------}}}
