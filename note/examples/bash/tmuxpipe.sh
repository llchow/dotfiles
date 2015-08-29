#!/bin/bash

#send keys to: 0:0.2
#get reply as stdout
#pipe to python process? 

pipe=$HOME/.tmppipe

trap "rm -f $pipe; exit" EXIT

if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi

prompt=$(tmux capture-pane -p -t 0:0.3 | grep -v "^$" | tail -n1)

tmux pipe-pane -t 0:0.3 "cat > $pipe"
tmux send-keys -t 0:0.3 'for i in $(seq 1 100); do echo $i; sleep 0.01; done; echo asdf; echo abcmbp51:dotfiles; ls' enter

while true
do
    lastline=$(tmux capture-pane -p -t 0:0.3 | grep -v "^$" | tail -n1)
    if [[ "$lastline" == $prompt ]]; then
        # close pipe
        echo Closing pipe
        tmux pipe-pane -t 0:0.3
        break
    fi
    sleep 0.1
done

cat < $pipe
echo
