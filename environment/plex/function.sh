sudo apt install python3-venv -y
python3 -m venv ~/certbot-venv
source ~/certbot-venv/bin/activate
pip install certbot certbot-dns-azure
certbot certonly   --authenticator dns-azure   --dns-azure-credentials $dir/.secrets/certbot/azure.ini   --dns-azure-propagation-seconds 30   -d $domain   --non-interactive --agree-tos --email <email>  -v
sudo certbot certonly   --authenticator dns-azure   --dns-azure-credentials $dir/.secrets/certbot/azure.ini   --dns-azure-propagation-seconds 30   -d $domain   --non-interactive --agree-tos --email <email>  -v
certbot certonly   --authenticator dns-azure   --dns-azure-credentials $dir/.secrets/certbot/azure.ini   --dns-azure-propagation-seconds 30   -d $domain   --non-interactive --agree-tos --email <email>  -v
mkdir -p ~/.config/letsencrypt
mkdir -p ~/.local/share/letsencrypt
mkdir -p ~/.local/log/letsencrypt
certbot certonly   --authenticator dns-azure   --dns-azure-credentials $dir/.secrets/certbot/azure.ini   --dns-azure-propagation-seconds 30   -d $domain   --non-interactive --agree-tos --email <email>  --config-dir $dir/.config/letsencrypt   --work-dir $dir/.local/share/letsencrypt   --logs-dir $dir/.local/log/letsencrypt   -v
chmod 600 $dir/.secrets/certbot/azure.ini
ls -tlra $dir/.secrets/certbot
certbot certonly   --authenticator dns-azure   --dns-azure-credentials $dir/.secrets/certbot/azure.ini   --dns-azure-propagation-seconds 30   -d $domain   --non-interactive --agree-tos --email <email>  --config-dir $dir/.config/letsencrypt   --work-dir $dir/.local/share/letsencrypt   --logs-dir $dir/.local/log/letsencrypt   -v
chmod 600 ~/.secrets/certbot/azure.ini
certbot certonly   --authenticator dns-azure   --dns-azure-credentials $dir/.secrets/certbot/azure.ini   --dns-azure-propagation-seconds 30   -d $domain   --non-interactive --agree-tos --email <email>  --config-dir $dir/.config/letsencrypt   --work-dir $dir/.local/share/letsencrypt   --logs-dir $dir/.local/log/letsencrypt   -v
openssl pkcs12 -export   -out $domain.pfx   -inkey $var/privkey.pem   -in $var/fullchain.pem   -certfile $var/fullchain.pem
openssl pkcs12 -export   -out $domain.pfx   -inkey $var/privkey.pem   -in $var/fullchain.pem   -certfile $var/fullchain.pem
openssl pkcs12 -export   -out $domain.pfx   -inkey $var/privkey.pem   -in $var/fullchain.pem   -certfile $var/fullchain.pem
openssl pkcs12 -in $domain.pfx -info -nodes