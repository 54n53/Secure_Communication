#!/bin/bash

# Function to securely delete files
secure_delete() {
    if command -v shred &>/dev/null; then
        echo "Using shred..."
        shred -n 5 -u "$1"
    else
        echo "Using openssl..."
        openssl enc -aes-256-cbc -salt -in "$1" -out /dev/null
        rm -f "$1"
    fi
}

# File containing the private key in .pem format
PRIVATE_KEY="private_key.pem" # Modify the path to the private key

# Receive the encrypted message via netcat
echo "Waiting for encrypted message..."
nc -nlvp 1234 > received_encrypted_message.txt

# Decrypt the message using the public key
echo "Decrypting the message..."
openssl pkeyutl -decrypt -inkey "$PRIVATE_KEY" -in received_encrypted_message.txt -out decrypted_message.txt

echo "Decrypted message:"
cat decrypted_message.txt

# Prompt user if they want to securely delete temporary files
read -p "Do you want to securely delete the encrypted meessage? (Y/N): " response
if [[ "${response^^}" == "Y" ]]; then
    secure_delete "received_encrypted_message.txt"
fi

read -p "Do you want to securely delete the encrypted meessage? (Y/N): " response
if [[ "${response^^}" == "Y" ]]; then
    secure_delete "decrypted_message.txt"
fi

