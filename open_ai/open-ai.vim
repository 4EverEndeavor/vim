let b:chat_messages = []

function! ChatGptCodeCompletion(prompt)

    " first prepetory message
    let b:prep_message = {}
    let b:prep_message['role'] = 'user'
    let b:prep_message['content'] = "The following is meant to be used to automatically insert code. Return only the actual code. Do not include any formatting, quotes or meta characters, just code. \n"
    if len(b:chat_messages) ==# 0
        let b:chat_messages = add(b:chat_messages, b:prep_message)
    endif

    " file type or language specific message
    let filetype_message = {}
    let filetype_message['role'] = 'user'
    if &filetype == 'java'
        let filetype_message['content'] = 'This will be written in java.'
        let b:chat_messages = add(b:chat_messages, filetype_message)
    elseif &filetype == 'vim'
        let filetype_message['content'] = 'This will be written in vimscript.'
        let b:chat_messages = add(b:chat_messages, filetype_message)
    elseif &filetype == 'python'
        let filetype_message['content'] = 'This will be written in python.'
        let b:chat_messages = add(b:chat_messages, filetype_message)
    endif

    let b:prompt_message = {}
    let b:prompt_message['role'] = 'user'
    let b:prompt_message['content'] = a:prompt
    let b:chat_messages = add(b:chat_messages, b:prompt_message)
   
    " Escape special characters in URL and JSON data
    let escaped_prompt = shellescape(string(b:chat_messages))

    call WriteVimDictToJsonFile(b:chat_messages, g:vimHome . '/open_ai/chat-message-history.json')
    let python_script = g:vimHome . "/open_ai/open_ai.py"
    let run_chat_sh = 'python ' . python_script

    " Execute the shell script
    let response = system(run_chat_sh)

    let b:chat_reply = {}
    let b:chat_reply['role'] = 'system'
    let b:chat_reply['content'] = response
    let b:chat_messages = add(b:chat_messages, b:chat_reply)

    let @c = response
    execute ':normal! "cp'

endfunction

nnoremap <leader>c :call ChatGptCodeCompletion("")<left><left>
