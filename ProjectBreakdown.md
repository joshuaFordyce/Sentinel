 Project Breakdown
sentinel.sh: The Bash entry point for local checks.

sentinel_analyzer.py: The Python script for gathering system data. Uses psutil and subprocess.

sentinel_reporter.py: The Python script for data aggregation, report generation, and alerting.

salt/: Contains the SaltStack states and pillars for deployment.

.github/workflows/: The CI/CD pipeline definition using GitHub Actions.

docker-compose.yml: The file defining the containerized test environment.

