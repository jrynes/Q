
- if [ "$ENVIRONMENT" = "lab" ]; then cp src/environments/environment.lab.ts src/environments/environment.ts; else cp src/environments/environment.prod.ts src/environments/environment.ts; fi
