git diff --name-only develop..release-2.31 | xargs -I {} sh -c 'echo "File: {}"; git log -1 --pretty=format:"Last modified by: %an on %ad | Commit: %h - %s" release-2.31 -- "{}"; echo ""' > file_modifications.txt

