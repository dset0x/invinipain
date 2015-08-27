#!/bin/sh

# This script kind of tries to list all your virtualenvs, their remotes and
# branches. Haven't used it in a long time, but probably useful if you keep
# losing your stuff.

for venv in ~/.virtualenvs/*; do
    if [ -d "$venv" ]; then
        echo "$venv"
        for i in $venv/src/*; do
            echo
            echo "    $(basename "$i")"
            echo
            (cd "$i" && git branch -v | sed "s/^/        /")
            echo
            (cd "$i" && git remote -v | sed "s/^/        /")
        done
        echo
    fi
done
