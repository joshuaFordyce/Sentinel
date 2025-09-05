Phased Development Plan 📈
Phase 1: The OS Health Check (Bash Script)
This phase focuses on the lightweight, high-performance monitoring of the host operating system. The goal is to catch major system-level issues immediately.

Task 1.1: Write the db_check.sh script. It should use vmstat to check for CPU context switches and a high run queue length.

Task 1.2: Use iostat to check for disk I/O latency (await) and disk utilization (%util).

Task 1.3: Check for swap usage using free -m. If any swap is used, the script should return a non-zero exit code.

Task 1.4: Verify the database service (postgresql or mysql) is running using systemctl is-active.

Phase 2: The Database Deep Dive (Python Script)
This phase extends the agent's capabilities to perform detailed database and OS-level analysis that a shell script can't handle.

Task 2.1: The Python script (db_analyzer.py) will use the subprocess module to execute and parse the output of OS-level commands for more nuanced metrics, such as:

I/O Scheduler: Read and report on the I/O scheduler (cat /sys/block/sda/queue/scheduler).

Huge Pages: Check the number of Huge Pages from /proc/meminfo to confirm they are configured and being used.

Kernel Parameters: Read and report on key kernel parameters like vm.swappiness and kernel.pid_max using sysctl.

Task 2.2: Connect to the database using psycopg2 or mysql-connector-python to:

Get a list of the top 10 slowest running queries.

For each slow query, run an EXPLAIN ANALYZE and identify potential issues.

Task 2.3: Format all collected metrics (OS and database) into a single, clean JSON object and expose it via a simple web server.

Phase 3: Automation & Observability (Salt & Prometheus/Grafana)
This phase integrates the agent with the broader SRE ecosystem, moving from a local tool to a fleet-wide monitoring solution.

Task 3.1: Create a Salt State file (db_sentinel.sls) to automate the deployment of both the shell and Python scripts. This state will also manage the installation of dependencies.

Task 3.2: Configure a cron job using Salt to run the db_check.sh script on a set interval.

Task 3.3: Set up a Prometheus server to scrape the metrics endpoint on each database host. The configuration file will use relabel_configs to enrich the metrics with host and database information.

Task 3.4: Create a Grafana dashboard that visualizes all the collected metrics. This dashboard should include panels for:

Database connection counts and query latency.

OS metrics like CPU usage, I/O wait, and available memory.

A table showing the top slowest queries from the database.

Task 3.5: Implement a remediation pillar in Salt, which the SRE can use to automatically apply OS-level tuning (e.g., setting vm.swappiness=1 or changing the I/O scheduler) with a single command.

