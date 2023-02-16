#! /usr/bin/env bash

for i in *.pdf; do
	password=$(openssl rand -base64 21)
	stapler -u "$password" cat "$i" "$i-encrypted.pdf"
	echo "${i}: $password" >> pdf-passwords.txt
done
