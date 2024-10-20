#!/bin/bash

# Define the list of users
users=("itzkaguya" "renelzx" "rsuntk" "brokenedtz")
length=${#users[@]}

# Function to display the menu with the selected option highlighted
display_menu() {
    clear
    echo "Select a user to switch (use Up/Down arrow keys and Enter):"
    for i in "${!users[@]}"; do
        if [ "$i" -eq "$selected" ]; then
            echo -e "\e[1;32m> ${users[$i]}\e[0m"  # Highlight selected option
        else
            echo "  ${users[$i]}"
        fi
    done
}

# Variables to track the current selection
selected=0

# Infinite loop to capture user input
while true; do
    display_menu

    # Read a single key press
    read -rsn3 key  # Read 3 characters for arrow keys

    case "$key" in
        $'\x1b[A')  # Up arrow
            if [ "$selected" -gt 0 ]; then
                ((selected--))
            else
                selected=$((length - 1))  # Wrap around to the last option
            fi
            ;;
        $'\x1b[B')  # Down arrow
            if [ "$selected" -lt $((length - 1)) ]; then
                ((selected++))
            else
                selected=0  # Wrap around to the first option
            fi
            ;;
        "")  # Enter key
            chosen_user="${users[$selected]}"
            echo "Switching to user: $chosen_user"
            sudo -u "$chosen_user" -i
            exit
            ;;
    esac
done
