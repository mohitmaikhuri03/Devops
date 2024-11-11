#!/bin/bash

# Global variables
action=""
branch_name=""
target_branch=""

# Process command-line options
while getopts "lb:d:m:r1:2:" opt; do
  case $opt in
    b)
        action="Create"
        branch_name="$OPTARG"
      ;;
    d)
        action="Delete"
        branch_name="$OPTARG"
      ;;
    l)
        action="List"
      ;;
    m)
        action="Merge"
      ;;
    r)
        action="Rebase"
      ;;
    1)
        branch_name="$OPTARG"
      ;;
    2)
        target_branch="$OPTARG"
      ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
      ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
      ;;
  esac
done

# Define the branch actions
list_branches () {
    echo "Listing all branches:"
    git branch -a
}

create_branch () {
    echo "Creating branch: ${branch_name}"
    git branch "$branch_name"
}

delete_branch () {
    echo "Deleting branch: ${branch_name}"
    git branch -d "$branch_name"
}

merge_branches () {
    echo "Merging branch '$branch_name' into '$target_branch'"
    git checkout "$target_branch"
    git merge "$branch_name"
}

rebase_branches () {
    echo "Rebasing branch '$branch_name' onto '$target_branch'"
    git checkout "$branch_name"
    git rebase "$target_branch"
}

# Execute based on the selected action
case $action in
    "List")
        list_branches
        ;;
    "Create")
        create_branch
        ;;
    "Delete")
        delete_branch
        ;;
    "Merge")
        merge_branches
        ;;
    "Rebase")
        rebase_branches
        ;;
    *)
        echo "No valid action selected."
        exit 1
        ;;
esac
