# Secure_Communication
Data (message) is shared via a socket, but it is encrypted using public key (.pem).

## Programs:
### Python:
 - send_message_python.py (Sender): Encrypt a message and then send it (cryptogram) to the receiver
 - receive_message_python.py (Receiver): Receives the message and decrypt it to get the original message.
 
### Shell:
 - send_message_shell.sh (Sender):
 - receive_message_shell.sh (Receiver):

## Key generation (.pem)
This is an example to generate the pair .pem keys (public and private).
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:4096
openssl rsa -pubout -in private_key.pem -out public_key.pem

## Future upgrades
- The first message indicates the file format to be sent.
- Use of hybrid encription, AES to encrypt data an RSA to send the AES key to the receiver. openssl rand -base64 32 > aes_key.txt 
