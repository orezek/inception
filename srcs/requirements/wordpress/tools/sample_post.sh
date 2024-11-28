#!/bin/bash
set -e

echo "Updating WordPress 'Hello World!' Post"

# Define the new title and content for the Hello World! post
NEW_TITLE="Hello from the hell of containers"
NEW_CONTENT="Welcome to the wonderful world of overengineering, where Docker containers rule supreme, \
and simplicity is just a fairy tale. In this delightful project, you’ll juggle TLS configurations, \
craft forbidden links, and master the dark arts of multi-container orchestration. Perfect? Good, \
because anything less means your bonus points go up in smoke. Enjoy the ride!"

# Check if WordPress is installed
if wp core is-installed --path=/var/www/html --allow-root; then
    # Find the ID of the "Hello World!" post
    POST_ID=$(wp post list --post_type=post --title="Hello world!" --field=ID --path=/var/www/html --allow-root)

    if [ -n "$POST_ID" ]; then
        # Update the title and content of the Hello World! post
        wp post update $POST_ID \
            --post_title="$NEW_TITLE" \
            --post_content="$NEW_CONTENT" \
            --path=/var/www/html \
            --allow-root
        echo "'Hello World!' Post updated successfully."
    else
        echo "'Hello World!' Post not found. No updates made."
    fi
else
    echo "WordPress is not installed. Skipping 'Hello World!' Post update."
fi
