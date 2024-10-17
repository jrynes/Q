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

    # Get all commit details for this file before the specified cutoff
    $commitDetails = git log --pretty=format:"%H|%an|%s|%ad|%cd" --date=iso -- $file --before="$dateCutoff"

    # Filter commits to find the last one with an author date before the cutoff
    $lastCommit = $commitDetails | Where-Object { 
        $parts = $_ -split "\|"
        $authorDate = [datetime]::Parse($parts[3]) # Parse author date
        $authorDate -lt [datetime]::Parse($dateCutoff)
    } | Select-Object -Last 1

    # Output the last commit for debugging
    Write-Host "Last commit for $file: $lastCommit"

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
