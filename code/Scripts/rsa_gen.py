from OpenSSL import crypto

HOSTNAME = "127.0.0.1"
#Run once to generate private.key and server.crt
keypair = crypto.PKey()
keypair.generate_key(crypto.TYPE_RSA, 4096)
#print(crypto.dump_privatekey(crypto.FILETYPE_PEM, keypair))
#print(crypto.dump_publickey(crypto.FILETYPE_PEM, keypair))
with open('private.key', 'wb') as f:
    f.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, keypair))

cert = crypto.X509()
cert.get_subject().C = "IT"
cert.get_subject().ST = "LAquila"
cert.get_subject().L = "LAquila"
cert.get_subject().O = "Massacio"   #organization
cert.get_subject().OU = "SchoolSec" #organization unit name
cert.get_subject().CN = HOSTNAME
cert.set_serial_number(1000)
cert.gmtime_adj_notBefore(0)
cert.gmtime_adj_notAfter(10*365*24*60*60) # set validity to 10 years
cert.set_issuer(cert.get_subject()) #self-signed
cert.set_pubkey(keypair)
cert.sign(keypair, 'sha256')

with open('server.crt', 'wb') as f:
    f.write(crypto.dump_certificate(crypto.FILETYPE_PEM, cert))
