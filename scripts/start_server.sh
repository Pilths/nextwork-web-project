#!/bin/bash
set -euo pipefail

echo "Starting web services..."
systemctl enable tomcat.service httpd.service
systemctl start tomcat.service
systemctl start httpd.service
