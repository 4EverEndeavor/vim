function! FindPackageName()
    let prev_reg = @0
    execute "normal! ggwvt;y"
    let package_name = @0
    let @0 = prev_reg
    return package_name
endfunction

function! FindClassName()
    let filename = expand('%:t')
    let file_split = split(filename, "[.]")
    let class_name = file_split[0]
    return class_name
endfunction

function! FindParametersNope()
    let l:start_res = searchpos(FindClassName() . '(', "w")
    let l:start_res = searchpos('(', "w")
    let l:stop_res = searchpos(')', "w")
    let l:start_line = l:start_res[0]
    let l:stop_line = l:stop_res[0]
    echom "stop line: " . l:stop_line
    if l:start_line ==# l:stop_line
        echom "start == stop"
        let l:parameters = getline(l:start_line)[l:start_res[1] : l:stop_res[1]]
        return l:parameters
    else
        echom "start != stop"
        let l:parameters = getline(l:start_line)[l:start_res[1] : ]
        for line in range(l:start_line, l:stop_line)
            echom "starting anoter line " . line
            let l:parameters .= getline(line)
        endfor
    return l:parameters
endfunction

function! FindParameters()
    let prev_reg = @0
    let @/ = FindClassName() . '('
    execute "normal! nelv%y"
    let parameters = @0
    let @0 = prev_reg
    let parameters = substitute(parameters, '\%x00', '', 'g')
    let parameters = substitute(parameters, '(', '', 'g')
    let parameters = substitute(parameters, ')', '', 'g')
    let parameters = split(parameters, ',')
    let parameters = map(parameters, 'trim(v:val)')
    return parameters
endfunction

function! NavigateToLastTest()
    let @/ = "@Test"
    execute "normal! N2j%"
endfunction

function! CreateTestFile(file_name)
    echom "Creating new test file: " . a:file_name
    let class_name = FindClassName()
    let lower_class_name = substitute(class_name, '\v^\w', '\=tolower(submatch(0))', '')
    let lines = ['package ' . FindPackageName() . ';']
    let parameters = FindParameters()
    call add(lines, '')
    call add(lines, 'import org.junit.jupiter.api.*;')
    call add(lines, 'import org.mockito.*;')
    call add(lines, 'import com.fasterxml.jackson.databind.ObjectMapper;')
    call add(lines, '')
    call add(lines, 'public class ' . class_name . 'Test')
    call add(lines, '{')
    for parameter in parameters
        let split_p = split(parameter)
        let p_name = split_p[-1]
        let p_type = split_p[-2]
        call add(lines, '    @Mock')
        call add(lines, '    private ' . p_type . ' _' . p_name . ';')
        call add(lines, '')
    endfor
    call add(lines, '    private AutoCloseable _autoCloseable;')
    call add(lines, '')
    call add(lines, '    @InjectMocks')
    call add(lines, '    private final ' . class_name . ' ' . lower_class_name . ' = new ' . class_name . '(')
    for parameter in parameters
        let split_p = split(parameter)
        let p_name = split_p[-1]
        call add(lines, '        _' . p_name . ',')
    endfor
    let lines[-1] = substitute(lines[-1], '.$', '', '')
    call add(lines, '    );')
    call add(lines, '')
    call add(lines, '    @BeforeEach')
    call add(lines, '    public void openMocks()')
    call add(lines, '    {')
    call add(lines, '          _autoCloseable = MockitoAnnotations.openMocks(this);')
    call add(lines, '    }')
    call add(lines, '')
    call add(lines, '    @AfterEach')
    call add(lines, '    public void closeMocks() throws Exception')
    call add(lines, '    {')
    call add(lines, '          _autoCloseable.close();')
    call add(lines, '    }')
    call add(lines, '}')
    execute ":edit " . a:file_name
    call append(0, lines)
endfunction

function! CreateUnitTest()
    let test_file = expand('%:p')
    let test_file = substitute(test_file, "src/main", "src/test", "")
    let test_file = substitute(test_file, "\\.java", "Test.java", "")
    let test_path = expand('%:p:h')
    let test_path = substitute(test_path, "src/main", "src/test", "")
    if !isdirectory(test_path)
        echom "creating new directory"
        call mkdir(test_path, 'p')
    endif
    if filereadable(test_file)
        echom "editing current file: " . test_file
        edit test_file
        NavigateToLastTest()
    else
        echom "creating new file" . test_file
        call CreateTestFile(test_file)
    endif
endfunction

nnoremap <leader>nt :call CreateUnitTest()<cr>
