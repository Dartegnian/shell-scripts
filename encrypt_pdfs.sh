#! /usr/bin/env bash

for i in *.pdf; do
	password=$(openssl rand -base64 21 | tr -dc 'a-zA-Z0-9' | head -c 21)
	stapler -u "$password" cat "$i" "$i-encrypted.pdf"
	echo "${i}: $password" >> pdf-passwords.txt
done
