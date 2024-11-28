#!/bin/bash
set -e

echo "Updating WordPress Sample Page"

# Define the new content for the sample page
NEW_TITLE="Welcome to WordPress Chaos"
NEW_CONTENT="Welcome to our gloriously complex Dockerized WordPress setup, where simplicity goes to die. \
In this labyrinth of containers, secrets, and rules, you’ll experience the joy of mandatory requirements, \
cryptic submission guidelines, and bonus tasks that only count if you’re perfect. \
Enjoy your stay at the intersection of system administration and masochism."

# Check if WordPress is installed
if wp core is-installed --path=/var/www/html --allow-root; then
    # Find the ID of the "Sample Page"
    PAGE_ID=$(wp post list --post_type=page --title="Sample Page" --field=ID --path=/var/www/html --allow-root)

    if [ -n "$PAGE_ID" ]; then
        # Update the title and content of the Sample Page
        wp post update $PAGE_ID \
            --post_title="$NEW_TITLE" \
            --post_content="$NEW_CONTENT" \
            --path=/var/www/html \
            --allow-root
        echo "Sample Page updated successfully."
    else
        echo "Sample Page not found. No updates made."
    fi
else
    echo "WordPress is not installed. Skipping Sample Page update."
fi
