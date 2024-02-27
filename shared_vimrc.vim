" Shared file that is updated via github

" Basic settings------------------ {{{
" make sure we can backspace through newlines
set backspace=indent,eol,start
set relativenumber
set numberwidth=4 " set the line numbers to equal 4 spaces
set hlsearch " highlight seaches 
set number
set sw=4
set wrap
set tabstop=4
set hlsearch
" set dictionary?
" set dictionary+=/root/.vim/dictionary.txt
" }}}

" syntax highlighting
if !exists("g:syntax_on")
    syntax enable
endif

nnoremap <space> viw

let mapleader = ","
let maplocalleader = "\\"

" Mappings---------------------- {{{
" nnoremap <leader>ev :vsplit /root/vim/shared_vimrc.vim<cr>G
nnoremap <leader>sv :source $MYVIMRC<cr>

" easy mapping for esc
inoremap jk <esc>
inoremap <esc> <nop>

" tile navigation
nnoremap K <c-w><up>
nnoremap J <c-w><down>
nnoremap L <c-w><right>
nnoremap H <c-w><left>
nnoremap <Up> <c-w>-
nnoremap <Down> <c-w>+
nnoremap <Left> <c-w><
nnoremap <Right> <c-w>>

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
    " autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" operator mappings, p maps to i-nside (-arenthesis
onoremap p i(
" map the operator to the first occurrence of return
onoremap b /return<cr>

" nnoremap <leader>g :silent execute "grep! -Iris " . shellescape(expand("<cWORD>")) . " ."<cr>:copen 15<cr>

" Plugins ---------------------------{{{
execute "source /Users/Eric/vim/plugins/fold-column.vim"
execute "source /Users/Eric/vim/plugins/grep-operator.vim"
execute "source /Users/Eric/vim/functional.vim"
execute "source /Users/Eric/vim/open_ai/open-ai.vim"
execute "source /Users/Eric/vim/template_generator.vim"
"-----------------------}}}

" emojis!
iabbrev rolling_eyes  <c-v>U1F644
iabbrev upsidedown_face <c-v>U1F643
iabbrev wink <c-v>U1F609
iabbrev shush <c-v>U1F92B
iabbrev thinking_face <c-v>U1F92B
iabbrev pensive <c-v>U1F614
iabbrev barf <c-v>U1F92E
iabbrev mind_blowing <c-v>U1F92F
iabbrev sunglasses <c-v>U1F60E	
iabbrev nerd <c-v>U1F913	
iabbrev monicle <c-v>U1F9D0
iabbrev confused <c-v>U1F615
iabbrev eyes_popping <c-v>U1F633
iabbrev poop <c-v>U1F4A9
iabbrev clown <c-v>U1F921
iabbrev shrug <c-v>U1F937
iabbrev facepalm <c-v>U1F926
iabbrev checked <c-v>U2705
