# Set environment-specific variables dynamically based on RUNNER_TAG
set-vars:
  stage: set-vars
  script:
    - if [[ "$RUNNER_TAG" == "pt_lab" ]]; then export ENVIRONMENT="insprint"; fi
    - if [[ "$RUNNER_TAG" == "preprod" ]]; then export ENVIRONMENT="preprod"; fi
    - echo "Using environment: $ENVIRONMENT"
  artifacts:
    reports:
      dotenv: var.env
