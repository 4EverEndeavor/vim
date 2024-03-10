function! DummyFunk1()
    echom "debugging fun1"
    let l:local_str = "local var1"
    let l:local_map = {"key":"val"}
    let l:local_list = ['one', 'two']
    return DummyFunk2(l:local_str, l:local_map, l:local_list)
endfunc

function! DummyFunk2(param_str, param_map, param_list)
    echom "debugging func2"
    let l:str_copy = deepcopy(a:param_str)
    let l:list_copy = deepcopy(a:param_list)
endfunc

function! Test_DummyFunk1()
    echom "inside test method"
    call DummyFunk1()
endfunc
