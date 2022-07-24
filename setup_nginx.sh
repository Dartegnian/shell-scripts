#! /usr/bin/env bash

timestamp=$(date +%Y-%m-%d-%H-%M-%S)

project_name=""
project_location=""
project_tld="local"

ssl_certificate=""
ssl_certificate_key=""
is_ssl_location_fixed=""

config_location="$HOME/.config"
config_filename="nginx_standard_config.conf"
config_details=""

function print_usage() {
	cat << EOF
Usage:
 setup_nginx.sh [folder of your website]
EOF
}

function check_user() {
	if [[ ! $USER == "root" ]]; then
		echo "You need to run this script as root. You are running it as $USER"
		exit 1
	fi
}

function setup_ssl_configuration() {
	if [[ -f "$config_location/$config_filename" ]]; then
		ssl_certificate=$(cat "$config_location/$config_filename" | tail -n 2 | head -n 1)
		ssl_key=$(cat "$config_location/$config_filename" | tail -n 1)
	else
		read -p "Type the location of your self-signed SSL certificate: " ssl_certificate
		read -p "Type the location of your self-signed SSL key: " ssl_certificate_key
		read -p "Is the location static? Lowercase yes/no? (If yes, a config file will be made and we won't ask you again): " is_ssl_location_fixed
		is_ssl_location_fixed=${is_ssl_location_fixed,,} # Set answer to lowercase
	fi

	if [[ $is_ssl_location_fixed == "yes" ]]; then
		echo $ssl_certificate >> "$config_location/$config_filename"
		echo $ssl_certificate_key >> "$config_location/$config_filename"
	fi
}

function setup_configuration_info() {
	project_name=$(sed -e "s:.*/::" <<< ${project_location,,})

	read -p "Type the TLD for your project (com, net, uwu, etc): " project_tld
	
	setup_ssl_configuration

	# DO NOT INDENT the following lines
	config_details=$(cat << EOF
# Redirect to HTTPS
server {
        listen 80;
        listen [::]:80;
        server_name $project_name.$project_tld www.$project_name.$project_tld;

        return 301 https://\$host\$request_uri;
}

server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        server_name $project_name.$project_tld www.$project_name.$project_tld;
        root /usr/share/nginx/html/$project_name.$project_tld;

        access_log /var/log/nginx/$project_name.$project_tld/access.log;
        error_log /var/log/nginx/$project_name.$project_tld/error.log;

        ssl_certificate $ssl_certificate;
        ssl_certificate_key $ssl_certificate_key;

        location / {
                index index.php index.html index.htm;
                try_files \$uri \$uri/ /index.php?;
        }

        include /etc/nginx/php_fastcgi.conf;
}
EOF
)
	echo "You will be given a chance to review your configuration. Feel free to make edits."
	sleep 2
	echo "$config_details" > "/tmp/${project_name}.${project_tld}_$timestamp"
	vi "/tmp/${project_name}.${project_tld}_$timestamp"
	config_details=$(cat "/tmp/${project_name}.${project_tld}_$timestamp")

	echo "Press Control+C now if you are unhappy with your config or you made a mistake with the earlier variables"
	printf "\n\nSetting up site: ${project_name}.${project_tld}\n"
	sleep 5
}

function make_logs() {
	echo "Making Nginx logs at /var/log/nginx/$project_name/"
	mkdir -p "/var/log/nginx/$project_name.$project_tld"
	touch "/var/log/nginx/$project_name.$project_tld/access.log"
	touch "/var/log/nginx/$project_name.$project_tld/error.log"
}

function setup_nginx_and_hosts() {
	# Delete any existing project configuration as a "just in case"
	if [[ -f "/etc/nginx/sites-available/${project_name}.${project_tld}" ]]; then
		rm "/etc/nginx/sites-available/${project_name}.${project_tld}"
	fi
	
	if [[ -L "/etc/nginx/sites-enabled/${project_name}.${project_tld}" ]]; then
		rm "/etc/nginx/sites-enabled/${project_name}.${project_tld}"
	fi

	if [[ -d "/usr/share/nginx/html/${project_name}.${project_tld}" ]]; then
		rm -rf "/usr/share/nginx/html/${project_name}.${project_tld}"
	fi

	echo "Setting up Nginx and /etc/hosts file"
	ln -s "$project_location" "/usr/share/nginx/html/${project_name}.${project_tld}"
	mv "/tmp/${project_name}.${project_tld}_$timestamp" "/etc/nginx/sites-available/${project_name}.${project_tld}"
	echo "127.0.0.1       ${project_name}.${project_tld}" >> /etc/hosts
	ln -s "/etc/nginx/sites-available/${project_name}.${project_tld}" "/etc/nginx/sites-enabled/${project_name}.${project_tld}"

	echo "Restarting Nginx..."
}

function main() {
	if [[ $1 ]]; then
		check_user
		project_location=$(realpath $1)
		setup_configuration_info
		make_logs
		setup_nginx_and_hosts
	else
		print_usage
	fi
}

main $1
