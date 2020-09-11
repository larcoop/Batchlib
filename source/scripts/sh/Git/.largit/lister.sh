#!/bin/bash
# Script to list supermodules and submodules

if [ -z "$1" ]; then
    curl -s -u fabio.sistemas:xkrshqbd7s775erjsickxtnhvzqvpvy5qlfwsyq46gfrzn46kotq http://tfs.larnet:8080/tfs/DESENVOLVIMENTO/LARGIT/_apis/git/repositories?api-version=3.1-preview | jq "[.value[].name | select(. | contains(\"_super\") | not)] - [.value[].name | select(. | contains(\"_super\")) | sub(\"_super\";\"\")] | .[]"
elif [ "$1" = super ]; then
    curl -s -u fabio.sistemas:xkrshqbd7s775erjsickxtnhvzqvpvy5qlfwsyq46gfrzn46kotq http://tfs.larnet:8080/tfs/DESENVOLVIMENTO/LARGIT/_apis/git/repositories?api-version=3.1-preview | jq "[.value[].name | select(. | contains(\"_super\"))] | .[]"
elif [ "$1" = sub ]; then
    curl -s -u fabio.sistemas:xkrshqbd7s775erjsickxtnhvzqvpvy5qlfwsyq46gfrzn46kotq http://tfs.larnet:8080/tfs/DESENVOLVIMENTO/LARGIT/_apis/git/repositories?api-version=3.1-preview | jq "[.value[].name | select(. | contains(\"_super\")) | sub(\"_super\";\"\")] | .[]"
elif [ "$1" = all ]; then
    curl -s -u fabio.sistemas:xkrshqbd7s775erjsickxtnhvzqvpvy5qlfwsyq46gfrzn46kotq http://tfs.larnet:8080/tfs/DESENVOLVIMENTO/LARGIT/_apis/git/repositories?api-version=3.1-preview | jq ".value[].name"
fi