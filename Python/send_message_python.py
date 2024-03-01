from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_OAEP
import socket

# Define the public key (replace 'public_key.pem' with the name of your public key file)
with open('public_key.pem', 'r') as f:
    public_key = RSA.import_key(f.read())

# Encrypt the message
cipher_rsa = PKCS1_OAEP.new(public_key)
message = "Secret message to encrypt"
encrypted_message = cipher_rsa.encrypt(message.encode())

print("Encrypted message in hexadecimal:", encrypted_message.hex())

# Send the encrypted message to the other machine
DEST_IP = '127.0.0.1' # Modify the destination IP
PORT = 1234 # Modify the linstening IP

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((DEST_IP, PORT))
    s.sendall(encrypted_message)

