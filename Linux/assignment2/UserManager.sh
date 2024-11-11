#!/bin/bash

action=$1
name=$2
gname=$3

# Create a group
case $action in
    addTeam)
        sudo groupadd "$name" && echo "Group Created"
        echo "$name" >> /home/maikhuri_03/assignment2.1/teams.txt
        ;;

    # Create a user
    addUser)
        if grep -q "$name" /home/maikhuri_03/assignment2.1/users.txt; then
            echo "User already exists"
        else
            # Create the user
            sudo useradd -m -G "$gname" ninjagrp && echo "User created"

            # Set correct permissions for home directory
            sudo chmod 751 /home/"$name"

            # Create the 'team' and 'ninja' directories
            sudo mkdir /home/"$name"/{team,ninja}

            # Change ownership of the directories
            sudo chown "$name":"$gname" /home/"$name"/team
            sudo chown "$name":ninjagrp /home/"$name"/ninja

            # Set permissions on the directories
            sudo chmod 770 /home/"$name"/team  # Changed permissions for group access
            sudo chmod 770 /home/"$name"/ninja

            # Append the user to the users.txt file
            echo "$name" >> /home/maikhuri_03/assignment2.1/users.txt
        fi
        ;;

    # Change the user shell
    changeShell)
        sudo usermod -s "$gname" "$name" && echo "Shell changed"
        ;;

    # Change the user password
    changePasswd)
        sudo passwd "$name" && echo "Password changed"
        ;;

    # To delete the user
    delUser)
        sudo userdel "$name" && echo "User deleted"
        sudo sed -i "/$name/d" /home/maikhuri_03/assignment2.1/users.txt
        ;;

    # To delete the team
    delTeam)
        sudo groupdel "$name" && echo "Group deleted"
        sudo sed -i "/$name/d" /home/maikhuri_03/assignment2.1/teams.txt
        ;;

    # To list the users and groups
    ls)
        if [ "$name" == "User" ]; then
            cat /home/maikhuri_03/assignment2.1/users.txt
        elif [ "$name" == "Team" ]; then
            cat /home/maikhuri_03/assignment2.1/teams.txt
        else
            echo "Invalid option"
        fi
        ;;
esac

