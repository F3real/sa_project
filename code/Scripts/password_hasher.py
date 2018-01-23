from werkzeug.security import generate_password_hash

plaintext_password = input("Enter password to hash:")
print(generate_password_hash(plaintext_password))