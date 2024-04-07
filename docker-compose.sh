#!/bin/bash
set -xeo pipefail
kompose convert -f docker-compose.yml
docker-compose down || true
rm page.pdf screenshot.png || true
docker-compose up --build
docker-compose logs puppeteer
docker cp k8s-ubuntu-desktop_puppeteer_1:/page.pdf .
docker cp k8s-ubuntu-desktop_puppeteer_1:/screenshot.png .
