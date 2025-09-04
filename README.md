# Sentinel: A Fleet Health Monitoring & Validation Tool 🩺

![Build Status](https://img.shields.io/github/actions/workflow/status/<your-github-username>/sentinel/ci.yml?branch=main)
![License](https://img.shields.io/badge/license-MIT-blue)

## 🌟 Overview

Sentinel is a production-grade tool designed for DevOps and SRE teams to automate the **health checks and state validation** of a fleet of Linux servers. It uses a **decentralized data collection** and a **centralized reporting** model, leveraging **Bash**, **Python**, and **SaltStack** to ensure system integrity and performance.

The project was developed to address common operational challenges in high-stakes, low-latency environments, such as those in algorithmic trading, by providing a single source of truth for the state of all production hosts.

## ✨ Key Features

- **Automated Host-Level Checks:** Gathers critical system metrics like CPU load, disk I/O, OS version, and more.
- **Configuration Management Integration:** Securely deployed and managed across the fleet using SaltStack.
- **Robust Reporting:** Generates detailed HTML reports summarizing the health of all hosts.
- **Critical Alerting:** Immediately sends alerts to a team's communication channel (e.g., Slack, Email) when a check fails.
- **CI/CD Pipeline:** Ensures every code change is automatically linted, tested, and deployed, demonstrating a professional, automated workflow.
- **Containerized Testing:** Provides a repeatable, isolated test environment using Docker and `docker-compose`.

## ⚙️ Architecture



## 🚀 Getting Started

To get started, clone the repository and set up a local testing environment using Docker.

### Prerequisites

- Docker
- Docker Compose

### Installation

1.  Clone the repository:
    ```bash
    git clone [https://github.com/your-username/sentinel.git](https://github.com/your-username/sentinel.git)
    cd sentinel
    ```
2.  Launch the test environment:
    ```bash
    docker-compose up --build
    ```
    This will bring up a Salt Master and several minions, automatically configuring them for testing.

## 💻 Usage

To run a full health check and generate a report, use the Salt orchestration runner from the master:

```bash
# From inside the salt master container
salt-run state.orch orchestrate.run_sentinel
