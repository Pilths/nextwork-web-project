#!/bin/bash
set -euo pipefail

echo "Starting web services..."

if command -v systemctl >/dev/null 2>&1; then
  systemctl daemon-reload || true
  systemctl enable tomcat9.service httpd.service 2>/dev/null || true
  systemctl start tomcat9.service 2>/dev/null || true
  systemctl start httpd.service 2>/dev/null || true
else
  echo "systemctl is unavailable; skipping service startup." >&2
fi
