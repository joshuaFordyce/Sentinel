#!/bin/zsh

echo "--- STARTING SENTINEL... --"

#--- Check what type of machine system is ---

get_environment_type() {
    if [ -f /.dockerenv]; then
        container_id=$(hostname)
        echo "docker-container $container_id"
    elif [ -n "$KUBERNETES_SERVICE_HOST"]; then
        pod_name=$(hostname)
        echo "kubernetes_pod $pod_name"
    else
        echo "bare_metal" 
    fi
    
    
}

environment=$(get_environment_type)


#--- function for basic system health checks ---"

basic_check() {

    local environment_output=$(get_environment_type)

    local environment_type=$(echo "$environment_output" | awk '{print $1}')
    local environment_id=$(echo "$environment_output" | awk '{print $2}')


    if [[ environment_type == "bare_metal" ]]; then
        diskUsage=$(df -h | awk 'NR > 1 && $5 ~ /%$/ && $5 > "50%" {print $0}')
        echo "${diskUsage}"

        cpuLoad=$(uptime | awkf "load averages:")

        availableMemory=$( free -m | awk 'NR==2{print $7}')
    elif [[ environment_type == "docker-container" ]]; then
        diskUsage=$(docker exec "$environment_id" df -h | awk 'NR > 1 && $5 ~ /%$/ && $5 > "50%" {print $0}')
        echo "${diskUsage}"

        cpuLoad=$(docker exec "$environment_id" uptime | awk -F "load averages:")
        echo "$cpuLoad"
        availableMemory=$(docker exec "$environment_id" free -m | awk 'NR==2{print $7}')
    elif [[ environment_type == "kubernetes-pod" ]]; then 
        echo "Performing checks inside a Kubernetes Pod..."

        
        # Ensure jq is installed

        if ! command -v jq &> /dev/null; then
            echo "jq is not installed. Attempting install"
            apt-get update && apt-get install -y jq
        fi 

        echo "Fetching metrics for pod" 

        # Get the API server address and token from the environment
        APISERVER=https://kubernetes.default.svc
        TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

        # Make the authenticated API call to the metrics endpoint
        json=$(curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
            -H "Authorization: Bearer $TOKEN" \
            -X GET $APISERVER/apis/metrics.k8s.io/v1beta1/pods)

        # ====================================================================
        # Step 3: Parse the JSON to extract the required data
        #
        # Explanation of the jq filter:
        # .items[]                          - Iterate over each item (pod) in the list.
        # | select(.metadata.name=="$1")    - Find the specific pod whose name matches the first argument ($1).
        # | .containers[]                   - Iterate over each container within that pod.
        # | {pod: .metadata.name,           - Create a JSON object with the pod's name, container's name, etc.
        #    container: .name,
        #    cpu: .usage.cpu,
        #    memory: .usage.memory}
        # ====================================================================
        parsed_metrics=$(echo "$json" | jq -r ".items[] | select(.metadata.name==\"$environment_id\") | .containers[] | {pod: .metadata.name, container: .name, cpu: .usage.cpu, memory: .usage.memory}")

        # Check if any metrics were found
        if [ -z "$parsed_metrics" ]; then
            echo "No metrics found for pod '$environment_id'. It may not be ready or the metrics server has not scraped its data yet."
        fi

        # ====================================================================
        # Step 4: Display the results in a clean format
        # ====================================================================
        echo "--- Metrics Report ---"
        echo "Pod: $(echo "$parsed_metrics" | jq -r .pod)"
        echo "Container: $(echo "$parsed_metrics" | jq -r .container)"
        echo "CPU Usage: $(echo "$parsed_metrics" | jq -r .cpu)"
        echo "Memory Usage: $(echo "$parsed_metrics" | jq -r .memory)"

        


        





        
}

echo "--- host system health checks are finished ---"

echo "--- Starting Postgres specific health checks ---"

echo "--- Starting Mysql specific health checks ---"

echo "--- Starting Redis specific health checks ---"

echo "--- Starting Cassandra specific health checks ---"


echo "--- Compiling the ---"







