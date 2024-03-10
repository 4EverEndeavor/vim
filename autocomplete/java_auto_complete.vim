function! WriteJavaClassMapJson(dict)
    let s:json = json_encode(a:dict)
    let s:path = expand('%:p:h') . '/JavaClassMap.json'
    call writefile([s:json], s:path)
endfunc

function! ReadJavaClassMapJson()
    let java_class_map = json_decode(join(readfile("/Users/eric/vim/autocomplete/JavaClassMap.json"), "\n"))
    return java_class_map
endfunc

function! GetFullyQualifiedCPName()
    let className = input('No autocomplete entry exists for the class name specified. Enter a new name: ')
    return className
endfunc

function! CreateNewMapEntry(class_name, java_class_map)
    " error
    l:new_java_entry = ClassStringToVimDict(class_name)
    let l:java_class_map[l:new_java_entry['class_name']] = l:new_java_entry
    WriteJavaClassMapJson(a:java_class_map)
    return l:new_java_entry
endfunc

function! CalculateJavaMethods(class_name)
    let output = systemlist("java JavaGateway . a:class_name)
    return output
endfunc

function! ClassStringToVimDict(class_name)
    let run_command = 'java JavaToJsonFile ' . class_name
    echom "run_command: . run_command
    :silent let run_output = system(run_command)
    echom "run_output: . string(run_output)
    let l:new_entry_dict = json_decode(join(readfile("NewJavaClass.json"), "\n"))
    return l:new_entry_dict
endfunc

function FindStatementText()
    let l:line = line('.')
    let l:col = col('.')
    if l:line ==# 1 || l:col ==# 1
        return ""
    endif
    let l:saved_register = deepcopy(@0)
    execute "normal! v?\\(;\\|{\\|}\\)\<cr>y"
    let l:statementText = @0
    " reset cursor and register
    call cursor(l:line, l:col)
    let l:statementText = substitute(l:statementText, '\%x00', "", "g")
    let l:statementText = substitute(l:statementText, '\s\{2,}', ' ', 'g')
    return l:statementText
endfunc

" There are these completion posistions:
" 11: line 0, col 0. packageName
" n1: line n, col 0. className
" AccessModifier
" static?
" ReturnType
" methodName
" Parameters
" StatementBegin
" final
" VarType
" VarName
" Methods
" Constuctor
" ServiceCall
function! GetCompletionContext()
    let l:line = line('.')
    let l:col = col('.')
    let l:statement = FindStatementText()
    if l:line ==# 1 && l:col ==# 1
        return "packageName"
    elseif l:col ==# 1
        return "className"
    endif
endfunc

function! FindBeginningOfWordPosition()
    " locate the start column of the current word
    let l:line = getline('.')
    let l:column = col('.')
    while l:column > 1 && l:line[column - 1] =~ '\a'
        let l:column -= 1
    endwhile
    return l:column
endfunc

function! ReturnCompletionsForBase(base)
    let l:candidates = []
    let l:java_class_map = ReadJavaClassMapJson()
    let l:comp_context = GetCompletionContext()
    echom "completion type: " . l:comp_context
    
    if l:comp_context ==# "packageName"
        let l:packageName = FindJavaPackageName() . ';'
        return [l:packageName]
    elseif l:comp_context ==# "className"
        let l:className = FindJavaClassName()
        let l:classComps = ['public class ' . l:className]
        let l:classComps += ['public static class ' . l:className]
        let l:classComps += ['public abstract class ' . l:className]
        let l:classComps += ['public abstract class ' . l:className . '\r']
        return {'words':l:classComps, 'refresh':'always'}
    elseif l:comp_context ==# "VarType"
        for class_name in keys(l:java_class_map)
            if class_name =~ '^' .. a:base
                call add(l:candidates, class_name)
            endif
        endfor
        return l:candidates
    elseif l:comp_context ==# "Methods"
        if !has_key(l:java_class_map, a:base)
            CreateNewMapEntry(a:base, l:java_class_map)
            let l:java_class_map = ReadJavaClassMapJson()
        endif
        return CalculateJavaMethods(l:java_class_map[a:base])
    endif
endfunc

function! CompleteJava(findstart, base)
    if a:findstart
        return FindBeginningOfWordPosition()
    else
        return ReturnCompletionsForBase(a:base)
    endif
endfunc

function! Test_CompleteJava()
    let l:completion = CompleteJava(0, "Obj")
    echom "completion: " . string(completion)
endfunc

autocmd CompleteDone 
set completefunc=CompleteJava
