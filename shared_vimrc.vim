" Shared file that is updated via github

" Basic settings------------------ {{{
" make sure we can backspace through newlines
set autochdir
set splitright
set backspace=indent,eol,start
set relativenumber
set numberwidth=4 " set the line numbers to equal 4 spaces
set hlsearch " highlight seaches 
set number
set sw=4
set wrap
set tabstop=4
set hlsearch
set wildmenu
set wildmode=longest:full,full
set foldmethod=syntax
set foldlevel=1
" set dictionary?
" set dictionary+=/root/.vim/dictionary.txt
" }}}

" sort for file explorer
let g:netrw_sort_sequence='src/,main/,test/,[\/]$,\<core\%(\.\d\+\)\=\>,\.h$,\.c$,\.cpp$,\~\=\*$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$,../,./'

" Try this for debugging:
" set verbose=9
" set verbosefile=/Users/eric/vim/verbose_output

" syntax highlighting
if !exists("g:syntax_on")
    syntax enable
endif

let mapleader = " "
let maplocalleader = "\\"

" easy mapping for esc
inoremap jk <esc>
inoremap <esc> <nop>

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

" Plugins ---------------------------{{{
execute "source " . g:vimHome . "/common/java_common.vim"
execute "source " . g:vimHome . "/common/vim_common.vim"
execute "source " . g:vimHome . "/plugins/fold-column.vim"
execute "source " . g:vimHome . "/plugins/grep-operator.vim"
execute "source " . g:vimHome . "/functional.vim"
execute "source " . g:vimHome . "/open_ai/open-ai.vim"
execute "source " . g:vimHome . "/template_generator.vim"
execute "source " . g:vimHome . "/autocomplete/java_auto_complete.vim"
execute "source " . g:vimHome . "/navigation.vim"
execute "source " . g:vimHome . "/debugger/common.vim"
execute "source " . g:vimHome . "/debugger/vim_debugger.vim"
execute "source " . g:vimHome . "/debugger/gradle_debugger.vim"
execute "source " . g:vimHome . "/help/help.vim"
execute "source " . g:vimHome . "/make/compile_java.vim"
execute "source " . g:vimHome . "/where_i_left_off.vim"
execute "source " . g:vimHome . "/test/java_unit_testing.vim"
execute "source " . g:vimHome . "/indexes.vim"
execute "source " . g:vimHome . "/git_gui/git_history.vim"
execute "source " . g:vimHome . "/refactor/js_refactor.vim"
execute "source " . g:vimHome . "/transpile.vim"
execute "source " . g:vimHome . "/documentionGen.vim"
execute "source " . g:vimHome . "/jsonFormatting.vim"
execute "source " . g:vimHome . "/templates/templates.vim"
execute "source " . g:vimHome . "/settersGetters.vim"
"-----------------------}}}

" java
iabbrev sout System.out.println("
iabbrev tE throws Exception

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

set tags+=/Users/eric/vim/tags

nnoremap <space> <Nop>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>x :25Vexplore /Users/eric/Rhombus/<cr>

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

nnoremap & :call NavigateToDeclaration()<cr>
noremap <leader>o :call SearchAndPopulateQuickfix()<cr>
noremap <leader>rj :call RefreshJavaFileIndex()<cr>
noremap <leader>rc :call RefreshJavaClassIndex()<cr>

" Testing
nnoremap <leader>tu :call RunJavaUnitTest()<cr>

" Save or update
nnoremap <leader>s :update<cr>
