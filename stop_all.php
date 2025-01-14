<?php
// Stop and delete all Podman containers
$output = [];
$returnCode = 0;

// Stop all running containers
exec("podman ps -q | xargs --no-run-if-empty podman stop 2>&1", $output, $returnCode);
if ($returnCode === 0) {
    echo "All running Podman containers stopped successfully.\n";
} else {
    echo "Error stopping Podman containers:\n" . implode("\n", $output) . "\n";
}

// Clear output and reset return code for the next command
$output = [];
$returnCode = 0;

// Remove all containers (stopped or running)
exec("podman ps -a -q | xargs --no-run-if-empty podman rm 2>&1", $output, $returnCode);
if ($returnCode === 0) {
    echo "All Podman containers removed successfully.\n";
} else {
    echo "Error removing Podman containers:\n" . implode("\n", $output) . "\n";
}
?>

