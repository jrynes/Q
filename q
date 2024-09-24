# Set environment-specific variables dynamically based on RUNNER_TAG
set-vars:
  stage: set-vars # Define the stage for this job as 'set-vars'
  script:
    # Check if the RUNNER_TAG is 'pt_lab'. If it is, set the ENVIRONMENT variable to 'insprint'
    - if [[ "$RUNNER_TAG" == "pt_lab" ]]; then export ENVIRONMENT="insprint"; fi
    # Check if the RUNNER_TAG is 'preprod'. If it is, set the ENVIRONMENT variable to 'preprod'
    - if [[ "$RUNNER_TAG" == "preprod" ]]; then export ENVIRONMENT="preprod"; fi
    # Output the current environment value to the console for debugging/logging purposes
    - echo "Using environment: $ENVIRONMENT"
  artifacts:
    reports:
      # Store the environment variables in the 'var.env' file, so that other jobs can use them later
      dotenv: var.env
