The architecture of Sentinel is designed to be simple, scalable, and resilient. It follows a decentralized model where the monitoring logic runs on the target systems, and the reporting and alerting logic is centralized.

Sentinel Minions (on each Host):

The core of the system resides here. The sentinel.sh script acts as the entry point, orchestrating checks on a scheduled basis (e.g., via cron).

It executes the Python Sentinel Analyzer (sentinel_analyzer.py), which uses system libraries to gather detailed, host-specific metrics (CPU, disk, OS version, etc.).

The analyzer's output is a structured JSON report.

Configuration Management (SaltStack):

This is the control plane. The Salt Master is responsible for securely deploying and configuring the Sentinel scripts on all target hosts (the Salt Minions).

It uses Salt States (.sls files) to ensure the scripts, Python dependencies, and cron jobs are present and in the desired state.

Centralized Reporter (on a separate host):

A dedicated host or a container with the Sentinel Reporter (sentinel_reporter.py) is used to collect and process the reports.

It uses Salt's file-gathering capabilities to pull the JSON reports from all minions.

This reporter script then analyzes the data, generates reports, and sends alerts.

CI/CD Pipeline (GitHub Actions):

This is the automated factory for your project. A GitHub Actions workflow automatically lints and tests your code and Salt States on every push.

If the tests pass, it deploys the new version of your project to your Salt Master for distribution.

