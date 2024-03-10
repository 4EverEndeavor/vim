function! DummyFunk1()
    echom "debugging func1" | call DB(2, execute(":let l:"))
    let l:local_str = "local var1" | call DB(3, execute(":let l:"))
    let l:local_map = {"key":"val"} | call DB(4, execute(":let l:"))
    let l:local_list = ['one', 'two'] | call DB(5, execute(":let l:"))
    return DummyFunk2(l:local_str, l:local_map, l:local_list) | call DB(6, execute(":let l:"))
endfunc

function! DummyFunk2(param_str, param_map, param_list)
    echom "debugging func2" | call DB(10, execute(":let l:"))
    let l:str_copy = deepcopy(a:param_str) | call DB(11, execute(":let l:"))
    let l:list_copy = deepcopy(a:param_list) | call DB(12, execute(":let l:"))
endfunc

function! Test_DummyFunk1()
    echom "inside test method" | call DB(16, execute(":let l:"))
    call DummyFunk1() | call DB(17, execute(":let l:"))
endfunc
