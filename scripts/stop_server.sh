#!/bin/bash
set -euo pipefail

if command -v systemctl >/dev/null 2>&1; then
  systemctl stop httpd.service 2>/dev/null || true
  systemctl stop tomcat.service 2>/dev/null || true
fi
