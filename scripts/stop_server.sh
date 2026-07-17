#!/bin/bash
set -euo pipefail

if pgrep httpd >/dev/null 2>&1; then
  systemctl stop httpd.service || true
fi

if pgrep tomcat >/dev/null 2>&1; then
  systemctl stop tomcat.service || true
fi
