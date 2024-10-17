# Set your repository path
$repoPath = "C:\path\to\your\repo"
Set-Location $repoPath

# Replace with your actual merge commit hash
$mergeCommitHash = "YOUR_MERGE_COMMIT_HASH"

# Specify the date cutoff
$dateCutoff = "2024-09-11"

# Get the list of files modified in the merge commit
$modifiedFiles = git diff --name-only $mergeCommitHash^ $mergeCommitHash

# Initialize an array to hold the output
$output = @()

foreach ($file in $modifiedFiles) {
    # Get the last commit details for this file on or before the specified date
    $lastCommit = git log --pretty=format:"%H|%an|%s|%ci" -- $file --before="$dateCutoff" | Select-Object -First 1

    if ($lastCommit) {
        # Split the last commit details using a different delimiter
        $commitDetails = $lastCommit -split "\|"

        # Enclose each field in double quotes
        $output += [PSCustomObject]@{
            FileName          = $file
            LastCommitHash    = '"' + $commitDetails[0] + '"'
            LastCommitAuthor  = '"' + $commitDetails[1] + '"'
            LastCommitMessage = '"' + $commitDetails[2] + '"'
            LastCommitDate    = '"' + $commitDetails[3] + '"'
        }
    } else {
        $output += [PSCustomObject]@{
            FileName          = $file
            LastCommitHash    = '"N/A"'
            LastCommitAuthor  = '"N/A"'
            LastCommitMessage = '"N/A"'
            LastCommitDate    = '"N/A"'
        }
    }
}

# Export the output to CSV
$output | Export-Csv -Path "modified_files_report.csv" -NoTypeInformation -Force

Write-Host "Report generated: modified_files_report.csv"
