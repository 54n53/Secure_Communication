#!/bin/bash

# Function to securely delete files
secure_delete() {
    if command -v shred &>/dev/null; then
        shred -u "$1" >/dev/null 2>&1
    else
        openssl enc -aes-256-cbc -salt -in "$1" -out /dev/null >/dev/null 2>&1
        rm -f "$1" >/dev/null 2>&1
    fi
}

# File containing the public key in .pem format
PUBLIC_KEY="public_key.pem"

# Prompt user to choose between file or text input
read -p "Do you want to send a file (F) or text (T)? " choice
if [[ "${choice^^}" == "F" ]]; then
    # Send a file
    read -p "Enter the path of the file to send: " file_path
    if [[ -f "$file_path" ]]; then
        echo "Encrypting and sending the file..."
        openssl pkeyutl -encrypt -pubin -inkey "$PUBLIC_KEY" -in "$file_path" -out encrypted_message.txt
        nc -w 1 127.0.0.1 1234 < encrypted_message.txt # Modify destination IP and port
        secure_delete "encrypted_message.txt"
        echo "File sent successfully."
    else
        echo "File not found or invalid path."
    fi
elif [[ "${choice^^}" == "T" ]]; then
    # Send text input
    read -p "Enter the text to send: " message
    echo "$message" > message.txt
    echo "Encrypting and sending the text..."
    openssl pkeyutl -encrypt -pubin -inkey "$PUBLIC_KEY" -in message.txt -out encrypted_message.txt
    nc -w 1 127.0.0.1 1234 < encrypted_message.txt # Modify destination IP and port
    secure_delete "message.txt"
    secure_delete "encrypted_message.txt"
    echo "Text sent successfully."
else
    echo "Invalid choice."
fi

