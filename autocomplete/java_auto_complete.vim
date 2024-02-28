let g:completionOnPeriod = 0

function! WriteJavaClassMapJson(dict)
    let s:json = json_encode(a:dict)
    let s:path = expand('%:p:h') . '/JavaClassMap.json'
    call writefile([s:json], s:path)
endfunc

function! ReadJavaClassMapJson()
    let java_class_map = json_decode(join(readfile("JavaClassMap.json"), "\n"))
    return java_class_map
endfunc

function! GetFullyQualifiedCPName()
    let className = input('No autocomplete entry exists for the class name specified. Enter a new name: ')
    return className
endfunc

function! CreateNewMapEntry(class_name)
    let java_class_map = ReadJavaClassMapJson()
    java_class_map[a:class_name] = GetFullyQualifiedCPName()
    WriteJavaClassMapJson(java_class_map)
endfunc

function! CalculateJavaMethods(class_name)
    let output = systemlist("java JavaGateway " . a:class_name)
    return output
endfunc

fun! CompleteJava(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    echom line[start]
    if line[start-1] == '.'
        echom "complete on period"
        let g:completionOnPeriod = 1
    else
        echom "complete not on period"
        let g:completionOnPeriod = 0
    endif
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    " find months matching with "a:base"
    echom "finding completions for base: " . a:base
    let res = []
    let candidates = []
    let java_class_map = ReadJavaClassMapJson()
    
    if g:completionOnPeriod ==# 0
        for class_name in keys(java_class_map)
          if class_name =~ '^' .. a:base
            call add(res, class_name)
          endif
        endfor
        return res
    else
        echom "base is: " . a:base
        if !has_key(java_class_map, a:base)
            CreateNewMapEntry(a:base)
            let java_class_map = ReadJavaClassMapJson()
        endif
        return CalculateJavaMethods(java_class_map[a:base])
    endif
  endif
endfunc

set completefunc=CompleteJava
