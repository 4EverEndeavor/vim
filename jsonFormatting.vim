function FormatJsonFile()
    :%s/\,/\,\r/g
    execute "normal! ggVG="
endfunc
