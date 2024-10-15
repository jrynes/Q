git diff --name-only develop..release-2.31 | while read file; do
    echo "File: $file"
    git log -1 --pretty=format:"Last modified by: %an on %ad | Commit: %h - %s" release-2.31 -- "$file"
    echo ""
done > file_modifications.txt
