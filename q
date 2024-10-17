# Set your repository path
$repoPath = "C:\path\to\your\repo"
Set-Location $repoPath

# Replace with your actual merge commit hash
$mergeCommitHash = "YOUR_MERGE_COMMIT_HASH"

# Get the commit hash of the parent (previous state) of the merge commit
$parentCommitHash = git rev-parse "$mergeCommitHash^1"

# Get the list of files modified in the merge commit
$modifiedFiles = git diff-tree --no-commit-id --name-only -r $mergeCommitHash

# Initialize an array to hold the output
$output = @()

foreach ($file in $modifiedFiles) {
    # Get the last commit details for this file on the develop branch before the merge
    $lastCommit = git log -1 --pretty=format:"%H,%an,%s,%ci" -- $file $parentCommitHash

    if ($lastCommit) {
        # Split the last commit details into components
        $commitDetails = $lastCommit -split ","
        
        $output += [PSCustomObject]@{
            FileName          = $file
            LastCommitHash    = $commitDetails[0]
            LastCommitAuthor  = $commitDetails[1]
            LastCommitMessage = $commitDetails[2]
            LastCommitDate    = $commitDetails[3]
        }
    } else {
        $output += [PSCustomObject]@{
            FileName          = $file
            LastCommitHash    = "N/A"
            LastCommitAuthor  = "N/A"
            LastCommitMessage = "N/A"
            LastCommitDate    = "N/A"
        }
    }
}

# Export the output to CSV
$output | Export-Csv -Path "modified_files_report.csv" -NoTypeInformation

Write-Host "Report generated: modified_files_report.csv"
