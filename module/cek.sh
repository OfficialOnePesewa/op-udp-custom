#!/bin/bash
# User checker for UDP Custom

# Example: check if a user exists and is active
USER_FILE="/etc/UDPCustom/users.txt"
if [[ ! -f "$USER_FILE" ]]; then
    echo "User database not found."
    exit 1
fi

echo "Active Users:"
while IFS=: read -r user limit expiration; do
    # Simple check if not expired (compare date)
    exp_epoch=$(date -d "$expiration" +%s 2>/dev/null)
    now_epoch=$(date +%s)
    if [[ $now_epoch -lt $exp_epoch ]]; then
        echo "- $user (Limit: ${limit}MB, Expires: $expiration)"
    fi
done < "$USER_FILE"
