function! SlimeIPythonToggle()
    if exists("g:slime_python_ipython")
        unlet g:slime_python_ipython
        echo "Slime_ipython is off"
    else
        let g:slime_python_ipython = 1
        echo "Slime_ipython is on"
    endif
endfunction

function! SlimeConfigSend(dry)
    if !exists("b:slime_config")
        SlimeConfig
    endif
    let cur_linenum = line('.')
    let tmux_pattern = '#\+tmuxwin:'
    let pane_pattern = '\(\d\?:\d\?\.\d\)'
    let exec_pattern = '#\(.\+\)'
    let target_pattern = tmux_pattern  . '\s*' . pane_pattern . '\s*' . exec_pattern
    let curr_line = getline('.')
    if curr_line =~ target_pattern
        let ml = matchlist(getline('.'), target_pattern)
        let saved_target = b:slime_config['target_pane']
        let b:slime_config['target_pane'] = ml[1]
        if a:dry
            echo b:slime_config
        endif
        let exec_statements = split(ml[2],"#")
        for statement in exec_statements
            if statement =~ '^\s*\(\d\+\)::\(\d\+\)\s*$'
                let mr = matchlist(statement, '^\s*\(\d\+\)::\(\d\+\)\s*$')
                if a:dry
                    echo mr[1] . ' to ' . mr[2]
                else
                    execute mr[1] . ',' . mr[2] . 'SlimeSend'
                endif
            else
                if a:dry
                    echo statement
                else
                    execute 'SlimeSend1 ' . statement
                endif
            endif
        endfor
        let b:slime_config['target_pane'] = saved_target
    endif
    execute "normal! " . cur_linenum . "G"
endfunction


function! SlimeMultiple() range
    if !exists("b:slime_config")
        SlimeConfig
    endif
    let saved_target = b:slime_config['target_pane']
    let targets = split(system("tmux -L " . shellescape(b:slime_config['socket_name']) . " list-panes -F '#{session_name}:#{window_index}.#{pane_index}'"))
    for target in targets
        let b:slime_config['target_pane'] = target
        execute a:firstline . ',' . a:lastline . 'SlimeSend'
    endfor
    let b:slime_config['target_pane'] = saved_target
endfunction


function! SlimeRepeat()
    if !exists("b:slimerepeat") || !exists("b:slimerepeat_savefirst")
        call SlimeRepeatConfig(0)
    endif
    if b:slimerepeat_savefirst && &mod && !empty(@%)
        write
    endif
    for cmd in b:slimerepeat
        if !empty(cmd)
            execute 'SlimeSend1 ' . cmd
        endif
    endfor
endfunction


function! s:SlimeRepeatSetSave()
    call inputsave()
    let yn = input('Save buffer first? (y/n): ')
    call inputrestore()
    if yn == 'y'
        let b:slimerepeat_savefirst = 1
    else
        let b:slimerepeat_savefirst = 0
    endif
endfunction


function! SlimeRepeatConfig(userange) range
    if !exists("b:slimerepeat_savefirst")
        call s:SlimeRepeatSetSave()
    endif

    if a:userange
        let b:slimerepeat = []
        let lnum = a:firstline
        while lnum <= a:lastline
            let b:slimerepeat += [getline(lnum)]
            let lnum += 1
        endwhile
    else
        call inputsave()
        "let cmd = input('Enter command: ', "", "buffer,dir,file")
        let cmd = input('Enter command: ')
        call inputrestore()
        if !empty(cmd)
            let b:slimerepeat = [cmd]
        else
            call s:SlimeRepeatSetSave()
        endif
    endif
endfunction


" must stay in same buffer
" cannot pause and restart
function! SlimeRecordToggle()
    if !exists("b:slime_record_on")
        " start recording: empty b:slime_record; let g:slime_paste_file
        let b:slime_record_on = 1
        let b:slime_record = []
        let g:slime_paste_file = "$HOME/.slime_paste"
        if !exists("b:slime_config")
            SlimeConfig
        endif
        nmap <buffer> <silent> <c-c><c-c> <Plug>SlimeLineSend :call SlimeSave()<cr>
        nmap <buffer> <silent> <c-c><c-d> <Plug>SlimeParagraphSend :call SlimeSave()<cr>
        xmap <buffer> <silent> <c-c><c-c> <Plug>SlimeRegionSend :call SlimeSave()<cr>
        imap <buffer> <silent> <c-c><c-c> <esc><Plug>SlimeLineSend :call SlimeSave()<cr>
        echo "Slime recording on"
    else
        " end recording: unlet g:slime_paste_file
        unlet b:slime_record_on
        unlet g:slime_paste_file
        nunmap <buffer> <c-c><c-c>
        nunmap <buffer> <c-c><c-d>
        xunmap <buffer> <c-c><c-c>
        iunmap <buffer> <c-c><c-c>
        echo "Slime stop recording"
    endif
endfunction


function! SlimeSave()
    if exists("b:slime_record_on")
        " read g:slime_paste_file; append to b:slime_record
        let b:slime_record += readfile(expand(g:slime_paste_file))
    endif
endfunction


function! SlimeReplay()
    if exists("b:slime_record")
        execute 'SlimeSend1 ' . join(b:slime_record, "\n")
    endif
endfunction
":call SlimeSave()<cr>


function! SlimeDefaultMappings()
    nmap <silent> <c-c><c-c> <Plug>SlimeLineSend
    nmap <silent> <c-c><c-d> <Plug>SlimeParagraphSend
    xmap <silent> <c-c><c-c> <Plug>SlimeRegionSend
    imap <silent> <c-c><c-c> <esc><Plug>SlimeLineSend
endfunction


" slime options
let g:slime_no_mappings = 1
let g:slime_target = "tmux"
let g:slime_python_ipython = 1
call SlimeDefaultMappings()
nmap <c-c>q :call SlimeRecordToggle()<cr>
nmap <c-c><c-r> :call SlimeReplay()<cr>
nmap <c-c>v <Plug>SlimeConfig

xmap <c-c><c-a> :call SlimeMultiple()<cr>
xmap <c-c><c-e> :call SlimeConfigSend(0)<cr>
nmap <c-c>p :call SlimeIPythonToggle()<cr>
nmap <c-c><c-x> :call SlimeRepeat()<cr>
xmap <c-c>f :call SlimeRepeatConfig(1)<cr>
nmap <c-c>f :call SlimeRepeatConfig(0)<cr>




" start recording
    " line:
        " slimesendlines: yank lines, send all at once
    " region:
        " slimesendop: yank lines, send all at once
    " paragraph:
        " slimesendop: yank lines, send all at once
    " just need to yank, append to list
" end recording
" replay
