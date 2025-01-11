<?php

// Function to get the Pod ID by Pod Name
function get_pod_id_by_name($pod_name) {
    // Execute podman ps command to list containers and their names
    $command = "podman ps --format '{{.ID}} {{.Names}}'";
    exec($command, $output, $result_code);

    if ($result_code !== 0) {
        echo "Failed to retrieve pod information.\n";
        return null;
    }

    // Search for the pod name in the output
    foreach ($output as $line) {
        list($pod_id, $name) = explode(" ", $line, 2);
        if ($name === $pod_name) {
            return $pod_id;
        }
    }

    // If pod is not found
    echo "Pod with name '$pod_name' not found.\n";
    return null;
}

// Get the Pod name from the command line arguments
if ($argc != 2) {
    echo "Usage: php get_pod_id.php <pod_name>\n";
    exit(1);
}

$pod_name = $argv[1];

// Get the pod ID by name
$pod_id = get_pod_id_by_name($pod_name);

if ($pod_id) {
    echo "$pod_id\n";
} else {
    echo "No Pod ID found for '$pod_name'.\n";
}


