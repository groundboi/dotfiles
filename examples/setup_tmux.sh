#!/bin/bash

if [ $# -eq 0 ]
then
    SESSNAME="someproj"
else
    SESSNAME="$1"
fi

tmux new -s $SESSNAME -d
tmux rename-window -t $SESSNAME dev
tmux send-keys -t $SESSNAME 'nvim'
tmux split-window -h -t $SESSNAME
tmux send-keys -t $SESSNAME 'echo -e "\n\nStart a grouped session in a new terminal with \`tmux new -s Other -t '$SESSNAME'\`"' C-m

tmux new-window -t $SESSNAME
tmux rename-window -t $SESSNAME test

tmux send-keys -t $SESSNAME 'Upper left thing'
tmux split-window -v -t $SESSNAME
tmux send-keys -t $SESSNAME 'Lower left thing'
tmux split-window -h -t $SESSNAME
tmux send-keys -t $SESSNAME 'Lower right thing'
tmux select-pane -t 1
tmux split-window -h -t $SESSNAME
tmux send-keys -t $SESSNAME 'Upper right thing'

tmux new-window -t $SESSNAME
tmux rename-window -t $SESSNAME review
tmux send-keys -t $SESSNAME 'cd ~/software/' C-m

tmux new-window -t $SESSNAME
tmux rename-window -t $SESSNAME misc

tmux select-window -t $SESSNAME:1
tmux select-pane -t 1
tmux attach -t $SESSNAME
