#!/bin/bash

# delete-label.sh
#
# This script removes the label from all repos in phetsims-repos
# The label needs to be removed manually from github-labels
#
# TODO: automatically update github-labels when this script is run

if [[ $1 = '' ]]
then
    echo "Usage: $0 label-name"
    exit 1
else
    label=$1
    echo "$label"
fi

read -p "Github Username: " username
read -sp "Github Password: " password
echo ''
creds=${username}:${password}

read -p "Do you want to update the list of repos(y/N)?" shouldUpdate
if [[ ${shouldUpdate} != 'N' ]]
then
    ./update-repos.sh ${username} ${password}
fi



echo 'For each repo, this script should print "204 No Content" to indicate success'

for repo in `cat phetsims-repos`
do
    repo=`echo ${repo}`
    url=https://api.github.com/repos/phetsims/${repo}/labels/${label}
    echo "Path: ${url}"
    echo "Result:"
    curl -isH 'User-Agent: "phet"' -u "$creds" -X DELETE ${url} | head -n 1
done

echo "Complete. Don't forget to remove the label from the github-labels file"

