<?php

// Function to find the latest pod folder number
function get_latest_pod_number($prefix = "pod_") {
    $latest_number = 0;
    $current_dir = getcwd();
    foreach (scandir($current_dir.'/../pods-data') as $file) {
        if (preg_match("/^" . preg_quote($prefix) . "(\d+)_var_www$/", $file, $matches)) {
            $latest_number = max($latest_number, (int)$matches[1]);
        }
    }
    return $latest_number;
}

// Get the latest pod number and increment it
$latest_pod_number = get_latest_pod_number();
$new_pod_number = $latest_pod_number + 1;

// Define folder names
$pod_var_folder = "../pods-data/pod_{$new_pod_number}_var_www";
$pod_var_folder2 = "../pods-data/pod_{$new_pod_number}_var_mysql";

// Create the directories if they don't exist
if (!file_exists($pod_var_folder)) {
    mkdir($pod_var_folder, 0755, true);
    //echo "Created directory: $pod_var_folder\n";
}
// Create the directories if they don't exist
if (!file_exists($pod_var_folder2)) {
    mkdir($pod_var_folder2, 0755, true);
    //echo "Created directory: $pod_var_folder2\n";
}

// Calculate the SSH port as 2222 + pod number
$new_port_http = 8080 + $new_pod_number;

// Calculate the SSH port as 2222 + pod number
$new_port = 2222 + $new_pod_number;

// Define the path to your SSH public key
$ssh_pub_key = "~/.ssh/id_rsa.pub";  // Assuming the default path for the SSH key

$zips_folder = "./zips";  // with core + core plugins

// Run the Podman command
$command = sprintf(
	'podman run -dit --name pod_%d --memory 512m --cpus 1 -v $(pwd)/%s:/var/www -v $(pwd)/%s:/var/lib/mysql -v %s:/root/.ssh/authorized_keys:ro -p %d:80 -p %d:22 wlp-pod:latest sleep infinity',
    $new_pod_number,
    $pod_var_folder,
    $pod_var_folder2,
    $ssh_pub_key,
    $new_port_http,
    $new_port
);

//echo "command: $command\n";
exec($command, $output, $result_code);

$SERVER='127.0.0.1';
// Check for command success
if ($result_code === 0) {
    $pod="pod_{$new_pod_number}";
    $pod_ip="$pod:$SERVER";
	$nextCommand='sudo sh add_host_mod_proxy_secure_https.sh '.$pod.' '.$new_port_http;
    $nextCommand2='sudo sh add_host_mod_proxy_insecure_http.sh '.$pod.' '.$new_port_http;

    echo json_encode(["pod"=>$pod_ip,"command"=>$command,
	    "nextCommandOnline"=>$nextCommand,
	    "nextCommandLocal"=>$nextCommand2
    ],JSON_PRETTY_PRINT).PHP_EOL;
} else {
    echo "Failed to start Podman container. Output:\n";
    print_r($output);
}


