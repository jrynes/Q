$files = git diff --name-only develop..release-2.31
foreach ($file in $files) {
    "File: $file" | Out-File -Append -FilePath file_modifications.txt
    git log -1 --pretty=format:"Last modified by: %an on %ad | Commit: %h - %s" release-2.31 -- $file | Out-File -Append -FilePath file_modifications.txt
    "" | Out-File -Append -FilePath file_modifications.txt
}
