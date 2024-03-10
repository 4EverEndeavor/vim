function! RefreshJavaFileIndex()
    :!find ~/Rhombus -type f -name "*.java" > ~/.vim_indexes/java_file_index
endfunc

function! RefreshJavaClassIndex()
    :!find ~/Rhombus -type f -name "*.class" > ~/.vim_indexes/java_class_index
endfunc

function! SearchAndPopulateQuickfix()
    " TODO use matchfuzzy( builtin to make this much better
    " TODO move this into a popup filter
    let input_str = input("Open: ")
    let fuzzy_matcher = substitute(input_str, '\(.\)', '\1.*', 'g')
    let file_lines = readfile(expand("~/.vim_indexes/java_file_index"))
    let matching_file_lines = filter(file_lines, 'v:val =~# ".*' . input_str . '.*\.java"')
    " let fuzzy_matching_file_lines = filter(file_lines, 'v:val =~# ".*' . fuzzy_matcher . '.*\.java"')
    " let fuzzy_and_full = matching_file_lines + fuzzy_matching_file_lines
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
