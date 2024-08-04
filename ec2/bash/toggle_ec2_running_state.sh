#!/bin/bash

# Function to display help
show_help() {
    echo "Usage: $0 <aws_profile> [region]"
    echo ""
    echo "Arguments:"
    echo "  aws_profile  The AWS CLI profile to use"
    echo "  region       The AWS region to query (default: us-east-1)"
    echo ""
    echo "Options:"
    echo "  --help       Display this help message"
}

# Check if the help option is provided
if [[ $1 == "--help" ]]; then
    show_help
    exit 0
fi

# Check if the required argument is provided
if [ $# -lt 1 ]; then
    show_help
    exit 1
fi

# Assign the arguments to variables
AWS_PROFILE=$1
REGION=${2:-us-east-1} # Default to us-east-1 if no region is provided

# List EC2 instances with their running state and Name tag
echo "Fetching EC2 instances in region $REGION with profile $AWS_PROFILE..."
echo ""
echo "---------------------------------------------------------------"
echo -e "Index\tInstance ID\t\tState\t\tName"
echo "---------------------------------------------------------------"
instances=$(aws ec2 describe-instances --profile "$AWS_PROFILE" --region "$REGION" --query "Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key=='Name'].Value | [0]]" --output text 2>/dev/null)

# Check if the AWS CLI command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch instances. Please check your AWS profile and region."
    exit 1
fi

if [ -z "$instances" ]; then
    echo "No instances found in the specified region."
    exit 1
fi

# Display instances with an index
echo "$instances" | awk '{ printf "%-5s %-20s %-10s %-30s\n", NR, $1, $2, $3 }'
echo "---------------------------------------------------------------"

# Split the instances into an array
IFS=$'\n' read -rd '' -a instance_array <<<"$instances"

# Prompt user to select an instance by index
echo -e "\nEnter the index number of the instance to toggle its state:"
read index

# Validate the index input
if ! [[ "$index" =~ ^[0-9]+$ ]] || [ "$index" -le 0 ] || [ "$index" -gt "${#instance_array[@]}" ]; then
    echo "Error: Invalid index number."
    exit 1
fi

# Get the instance ID, current state, and name from the selected index
selected_instance=${instance_array[$((index-1))]}
instance_id=$(echo $selected_instance | awk '{print $1}')
current_state=$(echo $selected_instance | awk '{print $2}')
instance_name=$(echo $selected_instance | awk '{print $3}')

echo -e "\nSelected instance ID: $instance_id"
echo "Instance Name: $instance_name"
echo "Current state of instance $instance_id is $current_state."
echo "---------------------------------------------------------------"

# Toggle the state
if [ "$current_state" == "running" ]; then
    echo "Stopping instance $instance_id..."
    aws ec2 stop-instances --profile "$AWS_PROFILE" --region "$REGION" --instance-ids "$instance_id" >/dev/null
    echo "Instance $instance_id is stopping."
elif [ "$current_state" == "stopped" ]; then
    echo "Starting instance $instance_id..."
    aws ec2 start-instances --profile "$AWS_PROFILE" --region "$REGION" --instance-ids "$instance_id" >/dev/null
    echo "Instance $instance_id is starting."
else
    echo "Instance $instance_id is in state $current_state and cannot be toggled."
fi
echo "---------------------------------------------------------------"

