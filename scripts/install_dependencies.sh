#!/bin/bash
set -euo pipefail

echo "Installing required packages..."

if command -v sudo >/dev/null 2>&1 && [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
else
  SUDO=""
fi

if [ "$(id -u)" -ne 0 ] && [ -z "${SUDO}" ]; then
  echo "This script must be run as root or with sudo privileges." >&2
  exit 1
fi

if command -v dnf >/dev/null 2>&1; then
  PKG_MANAGER="dnf"
elif command -v yum >/dev/null 2>&1; then
  PKG_MANAGER="yum"
else
  echo "No supported package manager found (yum/dnf)." >&2
  exit 1
fi

install_if_missing() {
  local pkg="$1"
  if rpm -q "$pkg" >/dev/null 2>&1; then
    echo "$pkg is already installed"
    return 0
  fi

  echo "Installing $pkg..."
  ${SUDO} "${PKG_MANAGER}" install -y "$pkg"
}

install_if_missing httpd
install_if_missing tomcat9

mkdir -p /etc/httpd/conf.d

if command -v sudo >/dev/null 2>&1 && [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
else
  SUDO=""
fi

if [ -w /etc/httpd/conf.d ]; then
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
elif [ -n "${SUDO}" ]; then
  ${SUDO} tee /etc/httpd/conf.d/tomcat_manager.conf >/dev/null <<'EOF'
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
else
  echo "Cannot write to /etc/httpd/conf.d; please run this script as root or with sudo privileges." >&2
  exit 1
fi
