# Define the output CSV file
$outputFile = "file_modifications.csv"

# Create the CSV headers
"File,Branch,Last Modified By,Last Edit Date,Commit Hash,Commit Message" | Out-File -FilePath $outputFile

# Get the list of files that differ between develop and release_2_31_0
$files = git diff --name-only develop..release_2_31_0
foreach ($file in $files) {
    # Check if the file content is different between the two branches
    git diff --quiet develop release_2_31_0 -- "$file"
    $contentDifferent = !$? # Capture the status; $? is False if the contents are different

    if ($contentDifferent) {
        # Get the latest commit details for the file in the 'develop' branch
        $developLog = git log -1 --pretty=format:"%an,%ad,%h,%s" develop -- "$file"
        
        # Get the latest commit details for the file in the 'release_2_31_0' branch
        $releaseLog = git log -1 --pretty=format:"%an,%ad,%h,%s" release_2_31_0 -- "$file"
        
        # Prepare the CSV rows for each branch
        $developOutput = "$file,develop,$developLog"
        $releaseOutput = "$file,release_2_31_0,$releaseLog"
        
        # Append the output to the CSV file
        $developOutput | Out-File -Append -FilePath $outputFile
        $releaseOutput | Out-File -Append -FilePath $outputFile
    }
}

Write-Output "Comparison saved to $outputFile"
