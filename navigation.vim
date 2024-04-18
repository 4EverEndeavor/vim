function! RefreshJavaFileIndex()
    :!find ~/Rhombus/rhombus-*/{src,service,api,data} -type f -name "*.java" > ~/.vim_indexes/java_file_index
endfunc

function! RefreshJavaClassIndex()
    :!find ~/Rhombus/rhombus-*/build/ -type f -name "*.class" > ~/.vim_indexes/java_class_index
endfunc

function! SearchAndPopulateQuickfix()
    " TODO use matchfuzzy( builtin to make this much better
    " TODO move this into a popup filter
    let input_str = input("Open: ")
    let fuzzy_matcher = substitute(input_str, '\(.\)', '\1.*', 'g')
    let file_lines = readfile(expand("~/.vim_indexes/java_file_index"))
    let matching_file_lines = filter(file_lines, 'v:val =~# ".*' . input_str . '.*\.java"')
    call setqflist(map(matching_file_lines, '{ "filename": v:val }'))
    copen 15
endfunction

function! NavigateToDeclaration()
    if &filetype == 'java'
        call JavaGoToDeclaration()
    elseif &filetype == 'vim'
      " Vim FileType code here
    elseif &filetype == 'python'
      " Python FileType code here
    endif
endfunc

function! JavaGoToDeclaration()
    execute "normal *"
    let word = @/
    execute '/\w\+ ' . word
    echom "word: " . word
endfunc

let s:choices = ['red', 'green', 'blue']
function! ColorSelected(id, result)
   echom a:id . " : " . s:choices[a:result-1]
endfunc
function! CreatePopupMenu()
    call popup_menu(s:choices, #{
            \ callback: 'ColorSelected',
            \ })
endfunc

