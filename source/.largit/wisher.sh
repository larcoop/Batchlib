#!/bin/bash
# Script to wish git-gui if status has changes

WISH='"C:/Program Files/Git/mingw64/bin/wish.exe" '
GITGUI='"C:/Program Files/Git/mingw64/libexec/git-core/git-gui" "--working-dir" '

if [[ `git status ${1} --porcelain` ]]; 
then
    eval $WISH$GITGUI\"$1\"
fi