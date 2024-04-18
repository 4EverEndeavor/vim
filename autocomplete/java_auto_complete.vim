function! IsMethod(line)
    return a:line =~ "\\(public\\|protected\\|private\\) \\(static\\)* \\(\[a-zA-Z\.]*\\) \\(\\a\\+\\)(\\(.*\\));"
endfunc

function! GetMethod(line)
    let l:method = {}
    let l:ml = matchlist(a:line, "\\(public\\|protected\\|private\\) \\(static\\)* \\(\[a-zA-Z\.]*\\) \\(\\a\\+\\)(\\(.*\\));")
    let l:method['modifier'] = l:ml[1]
    let l:method['static'] = !empty(l:ml[2])
    let l:method['returnType'] = l:ml[3]
    let l:method['name'] = l:ml[4]
    let l:method['params'] = l:ml[5]
    return l:method
endfunc

function! IsField(line)
    return a:line =~ "\\(public\\|protected\\|private\\) \\(static \\)*\\(final \\)*\\(\[a-zA-Z\.]*\\) \\(\\a\\+\\);"
endfunc

function! GetField(line)
    let l:field = {}
    let l:ml = matchlist(a:line, "\\(public\\|protected\\|private\\) \\(static \\)*\\(final \\)*\\(\[a-zA-Z\.]*\\) \\(\\a\\+\\);")
    let l:field['modifier'] = l:ml[1]
    let l:field['static'] = !empty(l:ml[2])
    let l:field['final'] = !empty(l:ml[3])
    let l:field['type'] = l:ml[4]
    let l:field['name'] = l:ml[5]
    return l:field
endfunc

function! GetClassNameFromOutput(line)
    let l:group = "\\(\[a-zA-Z\.]*\\)"
    let l:ml = matchlist(a:line, "class " . l:group)
    return l:ml[1]
endfunc

function! RefreshJavaCompleteInfo()
    let l:completions = {}
    let l:count = 0
    for l:classLine in readfile("/Users/eric/.vim_indexes/java_class_index")
        let l:count += 1
        echom l:count
        let l:jpOut = systemlist("javap " . l:classLine)
        let l:className = GetClassNameFromOutput(l:jpOut[1])
        for l:line in l:jpOut[2:-2]
            if IsMethod(l:line)
                let l:completions[l:className] = GetMethod(l:line)
            elseif IsField(l:line)
                let l:completions[l:className] = GetField(l:line)
            endif
        endfor
    endfor
    let l:json = json_encode(l:completions)
    call writefile([l:json], "/Users/eric/.vim_indexes/java_code_completions")
endfunc

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

function! RefreshJavaPClassInfo()
    let l:classInfoMap = {}
    for l:classLine in readfile("/Users/eric/.vim_indexes/java_class_index")
        let l:output = systemlist("javap " . l:classLine)
        let l:parsed = ParseJavapOutput(l:output)
        let l:classInfoMap[l:classLine] = l:parsed
    endfor
    call writefile("~/.vim_indexes/javap_class_info")
endfunc

function! ParseJavapOutput(outputLines)
    let l:obj = {}
    let l:obj['signature'] = a:outputLines[1]
    let l:obj['methods'] = []
    let l:obj['fields'] = []
    for l:ln in range(1, len(a:outputLines))
        let l:line = a:outputLines[l:ln]
        if l:line[-1:-1] != ";"
            echom l:line[-1:-1]
            echom l:line[-1:-1] != ";"
            continue
        elseif match(l:line, "(") > 0
            " is method
            let l:obj['methods'] += [l:line]
        else
            let l:obj['fields'] += [l:line]
        endif
    endfor
    return l:obj
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

" There are these completion positions:
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
    while l:column > 1 && l:line[l:column - 1] =~ '[a-zA-Z\.]'
        let l:column -= 1
    endwhile
    return l:column
endfunc

function! GetClassNameCompletions(base)
    " search in java class index
    " search in jdk classlist
endfunc

function! GetClassSignatureCompletions()
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
    let l:statement = FindStatementText() . a:base

    if l:line ==# 1 && l:col ==# 1
        " This is currently broken. Need to find java home first
        let l:packageName = "package " . FindJavaPackageName() . ';'
        return [l:packageName]
    elseif l:col ==# 1
        return GetClassSignatureCompletions()
    endif
    
    " new classes
    if a:base =~ '\a\+\.'
        return GetMethodsForBase(a:base)
    endif

endfunc

function! CompleteJava(findstart, base)
    if a:findstart
        " return FindBeginningOfWordPosition()
        debug let l:retval = FindBeginningOfWordPosition()
        return l:retval
    else
        " return ReturnCompletionsForBase(a:base)
        debug let l:retval = ReturnCompletionsForBase(a:base)
        return l:retval
    endif
endfunc

function! Test_CompleteJava()
    let l:completion = CompleteJava(0, "    Obj")
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
