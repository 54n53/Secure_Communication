from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_OAEP
import socket

# Define the private key (replace 'private_key.pem' with the path of your private key file)
with open('private_key.pem', 'r') as f:
    private_key = RSA.import_key(f.read())

# Listen for incoming connections and decrypt the message
IP = '0.0.0.0'  # Listen on all network interfaces
PORT = 1234 # Modify listening port

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((IP, PORT))
    s.listen()
    conn, addr = s.accept()
    with conn:
        print('Incoming connection from:', addr)
        encrypted_message = conn.recv(4096)
        
        encrypted_message_hex = encrypted_message.hex()
        print('Encrypted message in hexadecimal:', encrypted_message_hex)
        
        cipher_rsa = PKCS1_OAEP.new(private_key)
        decrypted_message = cipher_rsa.decrypt(encrypted_message)
        print('Decrypted message:', decrypted_message.decode())

