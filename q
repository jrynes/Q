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
    # Output the current file being processed for debugging
    Write-Host "Processing file: $file"

    # Get all commit details for this file before the specified cutoff date
    $commits = git log --pretty=format:"%H|%an|%s|%ad|%cd" --date=iso -- $file --before="$dateCutoff"

    # Initialize variables to track the last valid commit
    $lastCommit = ""
    $latestCommitDate = [datetime]::MinValue

    # Process each commit line
    foreach ($commit in $commits) {
        # Split commit details using a different delimiter
        $commitDetails = $commit -split "\|"

        # Get the commit date from the commit details (index 4 is commit date)
        $commitDate = [datetime]::Parse($commitDetails[4]) # Commit date

        # Check if this commit is more recent than our last valid commit
        if ($commitDate -gt $latestCommitDate) {
            $latestCommitDate = $commitDate
            $lastCommit = $commit
        }
    }

    # Prepare output
    if ($lastCommit) {
        # Split the last commit details again if needed
        $commitDetails = $lastCommit -split "\|"

        # Enclose each field in double quotes
        $output += [PSCustomObject]@{
            FileName          = $file
            LastCommitHash    = '"' + $commitDetails[0] + '"'
            LastCommitAuthor  = '"' + $commitDetails[1] + '"'
            LastCommitMessage = '"' + $commitDetails[2] + '"'
            LastCommitDate    = '"' + $commitDetails[4] + '"' # Commit date
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
