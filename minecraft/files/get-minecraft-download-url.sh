#!/bin/bash

[ $# -ne 1 ] && exit 1

varsion_to_get=$1
versions_file_url='https://launchermeta.mojang.com/mc/game/version_manifest.json'
versions_file_json=$(/bin/curl -m 2 -s $versions_file_url)
versions_array_length=$(echo $versions_file_json | /usr/bin/jsawk -n 'out(this.versions.length)')
version_url=""
counter=0

while [ $counter -lt $versions_array_length ]; do
        working_id=$(echo $versions_file_json | /usr/bin/jsawk -n "out(this.versions[$counter].id)")
        working_type=$(echo $versions_file_json | /usr/bin/jsawk -n "out(this.versions[$counter].type)")
        if [ $working_id == $1 -a $working_type = "release" ]; then
                version_url=$(echo $versions_file_json | /usr/bin/jsawk -n "out(this.versions[$counter].url)")
                break
        fi
        let counter=counter+1
done

[ -z "$version_url" ] && exit 1

download_file_url=$(/bin/curl -m 2 -s $version_url | /usr/bin/jsawk -n 'out(this.downloads.server.url)')

echo $download_file_url