function! SlimeConfigSend(dry)
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
endfunction

function! SlimeTargets() range
    let b:slime_multiple = []
    let tmux_pattern = '#\+tmuxwin:'
    let pane_pattern = '\(\d\?:\d\?\.\d\)'
    let target_pattern = tmux_pattern  . '\s*' . pane_pattern
    for linenum in range(a:firstline, a:lastline)
        let curr_line = getline(linenum)
        if curr_line =~ target_pattern
            let ml = matchlist(curr_line, target_pattern)
            let b:slime_multiple += [ml[1]]
        endif
    endfor
endfunction



function! SlimeMultiple()
    let saved_target = b:slime_config['target_pane']
    for target in b:slime_multiple
        let b:slime_config['target_pane'] = target
        execute "normal \<Plug>SlimeRegionSend"
    endfor
    let b:slime_config['target_pane'] = saved_target
endfunction
