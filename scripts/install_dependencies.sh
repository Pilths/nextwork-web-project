#!/bin/bash
set -euo pipefail

echo "Installing required packages..."
if ! command -v yum >/dev/null 2>&1; then
  echo "yum is not available on this system" >&2
  exit 1
fi

yum install -y tomcat httpd

mkdir -p /etc/httpd/conf.d

cat > /etc/httpd/conf.d/tomcat_manager.conf <<'EOF'
<VirtualHost *:80>
  ServerAdmin root@localhost
  ServerName app.nextwork.com
  DefaultType text/html
  ProxyRequests off
  ProxyPreserveHost On
  ProxyPass / http://localhost:8080/nextwork-web-project/
  ProxyPassReverse / http://localhost:8080/nextwork-web-project/
</VirtualHost>
EOF