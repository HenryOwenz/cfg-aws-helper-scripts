# CFG AWS Helper Scripts

Welcome to the `cfg-aws-helper-scripts` repository! This collection of scripts is designed to help you manage your AWS resources efficiently using the AWS Command Line Interface (CLI).

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Available Scripts](#available-scripts)
  - [toggle_ec2_running_state.sh](#toggle_ec2_running_statesh)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This repository contains a set of Bash scripts to automate common AWS tasks. These scripts aim to simplify interactions with AWS services and improve productivity by automating repetitive tasks.

## Prerequisites

Before using the scripts in this repository, ensure you have the following:

1. **AWS CLI**: Installed and configured with your AWS credentials. You can install the AWS CLI by following the instructions [here](https://aws.amazon.com/cli/).

2. **Bash Shell**: These scripts are designed to run in a Unix-like environment. Ensure you have access to a Bash shell (e.g., macOS, Linux, or Git Bash on Windows).

## Available Scripts

### EC2 
### toggle_ec2_running_state.sh

This script allows you to list EC2 instances and toggle their state (start/stop) interactively. It fetches instances from a specified AWS profile and region.

#### Features

- Lists EC2 instances with their instance ID, state, and Name tag.
- Prompts the user to select an instance by index number.
- Toggles the state of the selected instance (running to stopped, or stopped to running).

### General Instructions

1. **Make the script executable**:
   ```sh
   chmod +x <script_name>.sh
