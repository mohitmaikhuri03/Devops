#!/bin/bash
# Global variable
action="$1"
tag="$2"

# Function to create a tag
create_tag() {
    git tag "$tag"
    echo "Tag '$tag' created."
}

# Function to list tags
list_tags() {
    git tag
}

# Function to delete a tag
delete_tag() {
    git tag -d "$tag"
    echo "Tag '$tag' deleted."
}

# Check for valid actions using getopts
while getopts ":t:ld:" option; do
    case "$option" in
        t)  # Create tag
            tag="$OPTARG"
            create_tag
            ;;
        l)  # List tags
            list_tags
            ;;
        d)  # Delete tag
            tag="$OPTARG"
            delete_tag
            ;;
        *)  # Invalid option
            echo "Invalid option"
            ;;
    esac
done
