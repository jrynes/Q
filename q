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

    # Initialize the last commit variable
    $lastCommit = ""

    # Loop to find the last commit before the cutoff date
    do {
        # Get the last commit details for this file before the specified cutoff date
        $lastCommit = git log --pretty=format:"%H|%an|%s|%ad|%cd" --date=iso -- $file --before="$dateCutoff" | Select-Object -Last 1

        if (-not $lastCommit) {
            Write-Host "No commits found before cutoff date for $file."
            break
        }

        # Split the last commit details using a different delimiter
        $commitDetails = $lastCommit -split "\|"

        # Get the commit date from the commit details
        $commitDate = [datetime]::Parse($commitDetails[4]) # Commit date is at index 4

        # If the commit date is after the cutoff, continue to the next commit
        if ($commitDate -gt [datetime]::Parse($dateCutoff)) {
            Write-Host "Last commit is after cutoff date. Searching previous commits..."
            # Move to the next commit
            $lastCommit = git log --pretty=format:"%H|%an|%s|%ad|%cd" --date=iso -- $file --before=$commitDetails[4] | Select-Object -Last 1
        }

    } while ($commitDate -gt [datetime]::Parse($dateCutoff)) # Check using commit date

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
            LastCommitDate    = '"' + $commitDetails[4] + '"' # Change to commit date
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
