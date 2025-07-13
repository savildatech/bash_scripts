#!/bin/bash

#this script automates pulling files from an http server
#it checks and updates the files locally to match resources on the web server

#for this to work, you need to create a file with a list of resources like this: 
#directory/file.ext
#directory/file2.ext
#...

#do not add extra spaces or symbols as the script does not validate it!

resource_server=192.168.0.10 #edit this IP
port=80 #port to access the http web server on
resource_list_file=./resource_list #change this to the file with the resources you want synchronized
local_certs_path=/tmp/cats #this is the directory to sync to

#edit the following line to check a particular route for health checking, or comment it out entirely
[ ! $(curl -s http://$resource_server/check) == "Ready" ] && echo /check failed && exit 1

[ ! -f $resource_list_file ] && echo "could not find the file: $resource_list_file" && exit 1

for path in $(cat $resource_list_file); do
	url="http://$resource_server:$port/$path"
	curl_response=$(curl -fs $url)
	http_error=$?

	[ "$http_error" -ne 0 ] && echo "FAILED! curl returned: $http_error | url: $url" && continue
	filepath="$local_certs_path/$path"
	dirpath=$(dirname "$filepath")
	[ ! -d "$dirpath" ] && mkdir -p "$dirpath"
	[ ! -d "$dirpath" ] && echo failed to create directory && continue
	[ ! -f "$filepath" ] && echo no file exisits, creating it && touch "$filepath"
	[ ! -f "$filepath" ] && echo could not create file && continue
	[ "$(cat $filepath)" == "$curl_response" ] && echo they match....skipping && continue
	echo "$curl_response" > "$filepath"
	[ "$(cat $filepath)" == "$curl_response" ] && echo "successfully wrote file: $filepath"
done