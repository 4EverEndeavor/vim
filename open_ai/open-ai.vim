function! AskChatGpt(prompt)

    " Escape special characters in URL and JSON data
    let escaped_prompt = shellescape(a:prompt)

    " Construct the curl command with line continuation
    let python_script = "/Users/eric/vim/open_ai/open_ai.py"
    let run_chat_sh = 'python ' . python_script . ' ' . escaped_prompt

    " Execute the shell script
    let response = system(run_chat_sh)

    let @c = response
    execute ':normal! "cp'

endfunction

function! ChatGptVimScript(prompt)

    " Escape special characters in URL and JSON data
    let vim_prompt = "Vimscript code completion: " . a:prompt
    let escaped_prompt = shellescape(vim_prompt)

    " Construct the curl command with line continuation
    let python_script = "/Users/eric/vim/open_ai/open_ai.py"
    let run_chat_sh = 'python ' . python_script . ' ' . escaped_prompt

    " Execute the shell script
    let response = system(run_chat_sh)

    let @c = response
    execute ':normal! "cp'

endfunction

nnoremap <leader>ca :call AskChatGpt("")<left><left>
nnoremap <leader>cv :call ChatGptVimScript("")<left><left>
