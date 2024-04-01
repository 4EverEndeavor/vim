function! WriteJavaClassMapJson(dict)
    let s:json = json_encode(a:dict)
    let s:path = expand('%:p:h') . '/JavaClassMap.json'
    call writefile([s:json], s:path)
endfunc

function! ReadJavaClassMapJson()
    let java_class_map = json_decode(join(readfile(g:vimHome . "/autocomplete/JavaClassMap.json"), "\n"))
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
endfunc

function! FindBeginningOfWordPosition()
    " locate the start column of the current word
    let l:line = getline('.')
    if col('.') ==# 1
        return 1
    endif
    let l:column = col('.') - 1
    while l:column > 1 && l:line[column - 1] =~ '\a'
        let l:column -= 1
    endwhile
    return l:column
endfunc

function! GetClassNameCompletions()
    let l:className = FindJavaClassName()
    let l:classComps = ['public class ' . l:className]
    let l:classComps += ['public static class ' . l:className]
    let l:classComps += ['public abstract class ' . l:className]
    let l:class_comp_dt = {}
    let l:class_comp_dt['word'] = 'inserted text here'
    let l:class_comp_dt['abbr'] = 'abstract'
    let l:class_comp_dt['menu'] = 'ab menu'
    let l:class_comp_dt['info'] = 'ab info'
    let l:class_comp_dt['user_data'] = {'ex':"normal!"}
    let l:classComps += [l:class_comp_dt]
    return {'words':l:classComps, 'refresh':'always'}
endfunc

function! GetClassNameFromPath(path)
    return split(split(a:path, '/')[-1], '\.')[0]
endfunc

function! GetVariableTypeCompletions(base)
    let l:java_class_index = readfile(g:vimIndex . "/java_class_index", "r")
    let l:just_class_names = map(l:java_class_index, 'GetClassNameFromPath(v:val)')
    let l:filtered = filter(l:just_class_names, 'v:val !~ "\\$"')
    return matchfuzzy(l:filtered, a:base)
endfunc

function! ReturnCompletionsForBase(base)
    let l:candidates = []
    let l:java_class_map = ReadJavaClassMapJson()
    let l:line = line('.')
    let l:col = col('.')
    let l:statement = FindStatementText()

    if l:line ==# 1 && l:col ==# 1
        let l:packageName = "package " . FindJavaPackageName() . ';'
        return [l:packageName]
    elseif l:col ==# 1
        return GetClassNameCompletions(a:base)
    endif

    if l:statement =~ "fi\\{0,1}n\\{0,1}a\\{0,1}l\\{0,1}$"
        return ["final"]
    endif

    let l:matcher = "\\(;\\|{\\|}\\) \\(final\\)\\?"
    let l:matcher .= " \\a*"
    if l:statement =~ matcher
        return GetVariableTypeCompletions(a:base)
    endif

    let l:matcher .= " = "
    if l:statement =~ matcher
        return ['new '] + GetVariableTypeCompletions(a:base)
    endif

    let l:matcher .= "new "
    if l:statement =~ matcher
        return GetVariableTypeCompletions(a:base)
    endif

    let l:matcher .= "\\(\\w\\+\.\\)\\+"
    elseif l:statement =~ matcher
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

" function! HandlePostSelecttion(completed_item)
"     echom a:completed_item
"     execute "normal! o{func here}jk"
" endfunc

" autocmd CompleteDone *.java call HandlePostSelecttion(v:completed_item)
set completefunc=CompleteJava
set completeopt=menu,menuone,preview,longest,popup
set pumheight=12
