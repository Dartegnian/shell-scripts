#! /bin/sh

title_tag=$(curl $1 | grep -oP "(?<=<title>).*(?=<\/title>)")
download_directory="/home/$USER/Downloads"
directory_name=$(echo $title_tag | grep -oP -m 1 "(?<=- )([^-]+)(?= -)" | head -1)
directory_name="${directory_name/\//-}"

wget -P "$download_directory/$directory_name" -nd -r -l 1 -H -D i.4cdn.org,is2.4chan.org -A png,gif,jpg,jpeg,webm -R '?????????????s.*' $1
