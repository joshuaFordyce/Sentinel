Phase 1: Basic Bash Scripting and Host-Level Checks 🐚
The goal of this phase is to build a foundational Bash script that can run a series of simple, host-level checks. This will get you comfortable with fundamental shell scripting concepts.

Project Goal: A single Bash script that runs a series of checks on a local machine and outputs a report.

Concepts to Learn:

Bash Scripting Fundamentals: Variables, conditional logic (if/else, case), loops (for, while).

Command Substitution: Using $(command) to capture command output and store it in a variable.

Error Handling: Using set -e to exit on error and || true to gracefully handle a failed command.

Pipes and Redirection: Piping command output (|) and redirecting to a file (>).

Tasks:

Create a script named sentinel.sh.

Implement checks for basic system health:

Disk Usage: Use df -h to check if any file system is over 90%.

CPU Load: Use uptime to check the 5-minute load average.

Memory Usage: Use free -m to check available memory.

Service Status: Check if a critical service (e.g., sshd) is running using systemctl is-active.

Create a structured, readable report that logs the results of each check to sentinel_report.log.

Phase 2: Integrating with a High-Level Language (Python) 🐍
Bash is great for orchestration, but for complex logic, data parsing, and structured output, Python is the right tool. This phase forces you to integrate the two.

Project Goal: The sentinel.sh script now calls a Python script to perform more advanced checks and generate a JSON report.

Concepts to Learn:

Bash-Python Integration: Passing command-line arguments from Bash to a Python script using $@.

Python Libraries: Learn to use libraries like subprocess to run shell commands from Python, psutil for platform-independent system metrics, and json to handle structured data.

Structured Data: The importance of using structured formats like JSON or YAML for machine-readable output.

Exit Codes: Returning meaningful exit codes from your Python script to be used in Bash's control flow.

Tasks:

Create a Python script, sentinel_parser.py, that accepts a server's hostname as an argument.

In sentinel_parser.py, perform the following:

Run lscpu and parse its output to extract the number of CPU cores and threads.

Run lsblk -o NAME,ROTA and check if a drive is rotational (ROTA=1) or solid-state (ROTA=0). This is a common check for performance tuning.

Run cat /etc/os-release to get the OS version.

The Python script should then create a JSON object containing this information and print it to standard output.

Modify sentinel.sh to call sentinel_parser.py, capture its JSON output, and save it to a file named after the hostname (e.g., server01.json).

Phase 3: Scaling and Configuration Management Integration (SaltStack) 🧂
The previous phases focused on a single host. In a real-world scenario, you'd run these checks across a fleet of servers. This phase introduces a configuration management tool to manage the fleet. We'll use SaltStack since it's mentioned in the job description.

Project Goal: The sentinel.sh and sentinel_parser.py scripts are now deployed and executed on multiple virtual machines using SaltStack. The reports are aggregated.

Concepts to Learn:

SaltStack Fundamentals: Pillar (for sensitive or unique data), Grains (for static host data), and States (.sls files).

Orchestration: Using Salt's salt-run commands or a simple Python script to coordinate the execution across multiple minions.

Infrastructure as Code (IaC): The principle of defining and managing your infrastructure through code.

Tasks:

Set up a Salt master and a few Salt minions (e.g., using vagrant or docker-compose).

Create a Salt state (sentinel/init.sls) that does the following:

Distributes your sentinel.sh and sentinel_parser.py scripts to all minions.

Adds a cron job to execute sentinel.sh on a regular schedule.

Create a simple pillar file to define a list of hosts to be checked.

Create an orchestration file (orchestrate/run_sentinel.sls) that, when run from the master, executes sentinel.sh on a group of minions and then collects the generated reports (*.json) back to a central directory on the master.

Phase 4: Containerization for a Replicable Test Environment 🐳
Testing your scripts on real VMs can be slow and resource-intensive. Containers provide a lightweight, isolated, and repeatable environment for testing.

Project Goal: Create a Dockerized environment to automatically test your SaltStack states and Bash scripts.

Concepts to Learn:

Docker Fundamentals: Dockerfile (for building an image), docker-compose (for multi-container applications).

Container Networking: Understanding how to network a Salt master container to a Salt minion container.

Testing IaC with Containers: The practice of using disposable containers to test your configuration management code before deploying to real infrastructure.

Tasks:

Create a Dockerfile for a Salt master.

Create a Dockerfile for a Salt minion.

Write a docker-compose.yml file that orchestrates the following:

Starts a Salt master container.

Starts several Salt minion containers, each with a unique name.

Ensures that the minion containers can connect to and be managed by the master.

Write a simple shell script (test_sentinel.sh) that starts the docker-compose environment, runs your Salt orchestration to deploy and execute sentinel, and then checks for the existence of the generated report files. This script will serve as your automated test.

Phase 5: Production-Grade Python Tooling 🔨
This phase focuses on making the Python components of your project professional. It's about writing code that's not only functional but also maintainable, debuggable, and scalable.

Project Goal: Refactor sentinel_parser.py into a full-fledged, modular Python application with robust logging, configuration, and proper exception handling.

Concepts to Learn:

Configuration Management: Ditch hardcoded values. Use a library like python-decouple or configparser to manage settings from a .env file or environment variables. This is crucial for different environments (dev, staging, prod).

Structured Logging: Instead of simple print() statements, use Python's built-in logging module. Configure a logger that outputs structured logs (e.g., JSON format) to stdout. This makes the logs easily ingestible by a log aggregation system like Splunk or Elasticsearch.

Robust Error Handling: Use try...except blocks to handle potential failures gracefully, such as a command timing out or a file not being found. Log the full traceback for a more detailed debugging experience.

Command-Line Interface (CLI): Use a library like argparse to create a user-friendly CLI. This allows you to run sentinel_parser.py with different options, like a --verbose flag for debug-level logging.

Tasks:

Create a requirements.txt file listing all Python dependencies.

Use the logging module to log the start and end of each check, the results, and any failures.

Create a config.py to manage settings like API keys or host lists.

Refactor your Python code into a class or separate functions to improve readability and testability.

Phase 6: Monitoring, Alerting, and Reporting 📈
A production-grade tool doesn't just run; it also reports on its health and alerts on failures. This phase introduces monitoring and reporting features that are critical for SRE roles.

Project Goal: Add a mechanism to send alerts and generate a human-readable report from the collected data.

Concepts to Learn:

Monitoring Concepts: The difference between a metric (a value you can chart, like CPU usage) and a log (an event you can search for).

Webhooks/APIs: How to use Python libraries like requests to send data to external services.

Jinja Templating: Using Jinja to generate a clean, readable HTML or text report from the raw JSON data.

Tasks:

Create a new Python script, sentinel_reporter.py.

This script will:

Read all the JSON reports from Phase 2.

Analyze the data to identify anomalies (e.g., a host with unusually high disk usage compared to the fleet average).

Use Jinja to create an HTML report summarizing the findings.

Send the report via email using Python's smtplib or to a Slack/Microsoft Teams channel using a webhook.

Add an alerting mechanism: If a check fails (e.g., a critical service is down), the Python script should immediately send a critical alert to a channel or service like PagerDuty.

Phase 7: Building a CI/CD Pipeline 🚀
This is the ultimate step to demonstrate DevOps maturity. A CI/CD pipeline ensures that every change you make is automatically tested and deployed. It's a key part of the modern software development lifecycle.

Project Goal: Set up a CI/CD pipeline (e.g., using GitHub Actions) that automatically builds, tests, and deploys your Sentinel project.

Concepts to Learn:

Continuous Integration (CI): The process of automatically building and testing code whenever a change is pushed to a repository.

Continuous Deployment (CD): The process of automatically deploying tested code to a production environment.

Pipeline as Code: Writing a pipeline configuration file (.github/workflows/main.yml) that defines the entire process.

Linting and Static Analysis: Using tools like flake8 or pylint to check for code style and potential bugs.

Tasks:

Put your entire project (Bash and Python scripts, Salt states, requirements.txt) into a Git repository on GitHub.

Create a .github/workflows/sentinel_ci.yml file.

This workflow should:

Run on every push to the main branch or on pull requests.

Set up a Python environment.

Install dependencies.

Run linting checks on your Python code.

Run your Docker Compose test environment (from Phase 4) to ensure your Salt states work correctly.

If all checks pass, the pipeline can be configured to deploy the new version of your sentinel scripts to your Salt master.
