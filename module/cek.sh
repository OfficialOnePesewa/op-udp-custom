#!/bin/bash
echo "Active users:"
cat /etc/passwd | grep 'home' | grep 'false' | grep -v 'syslog' | awk -F: '{print $1}' | while read u; do
    exp=$(chage -l "$u" 2>/dev/null | grep "Account expires" | awk -F ': ' '{print $2}')
    echo "$u -> $exp"
done
