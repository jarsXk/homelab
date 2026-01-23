
if [ $(command -v docker | wc -c) -gt 0 ]; then
    log_message INFO "Cleaning docker networks"
    run_command "docker network prune -f" "Error cleaning docker networks"
    log_message INFO "Cleaning docker images"
    run_command "docker image prune -af" "Error cleaning docker images"
else
    log_message INFO "Docker not installed"
fi