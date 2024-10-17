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

        # Check the last commit's date
        $commitDetails = $lastCommit -split "\|"
        $commitDate = [datetime]::Parse($commitDetails[3]) # Get the author date from the commit details

        # If the commit date is after the cutoff, continue to the next commit
        if ($commitDate -gt [datetime]::Parse($dateCutoff)) {
            Write-Host "Last commit is after cutoff date. Searching previous commits..."
            # Move to the next commit
            $lastCommit = git log --pretty=format:"%H|%an|%s|%ad|%cd" --date=iso -- $file --before=$commitDetails[3] | Select-Object -Last 1
        }

    } while ($commitDate -gt [datetime]::Parse($dateCutoff)

    # Prepare output
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
