#!/bin/bash

# Script to suspend, lock the screen, or power off Arch Linux using different methods

# Prompt message
echo "What action do you want to perform?"
echo "1. Suspend"
echo "2. Lock the screen"
echo "3. Power off"
read -p "Select an option (1/2/3): " option

# Function to try different lock methods
function try_lock {
    for method in "$@"; do
        if command -v "$method" &> /dev/null; then
            echo "Attempting lock with $method..."
            if [ "$method" == "i3lock" ] && [ -n "$SSH_CONNECTION" ]; then
                # Simulate screen lock using systemd-inhibit if running over SSH
                systemd-inhibit --what=idle:sleep:shutdown --why="Screen lock" --mode=block -- "$method -c 000000"
            else
                $method
            fi
            if [ $? -eq 0 ]; then
                echo "Successful lock with $method."
                return 0
            else
                echo "Locking failed with $method."
            fi
        else
            echo "$method not found on the system."
        fi
    done

    echo "Could not lock the system with any method."
    return 1
}

# Verify the selected option
case $option in
    1)
        # Suspend
        sudo systemctl suspend
        ;;
    2)
        # Lock the screen using different methods
        try_lock \
            "enlightenment_remote -lock" \
            "xlock -mode blank" \
            "i3lock" \
            # Add more lock methods according to your configuration
        ;;
    3)
        # Power off
        sudo systemctl poweroff
        ;;
    *)
        # Invalid option
        echo "Invalid option. Exiting."
        ;;
esac

# End of the script

