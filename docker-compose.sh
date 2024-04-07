#!/bin/bash
kompose convert -f docker-compose.yml
docker-compose down || true
docker-compose up --build
docker-compose logs puppeteer
ocker cp k8s-ubuntu-desktop_puppeteer_1:/page.pdf .
docker cp k8s-ubuntu-desktop_puppeteer_1:/screenshot.png .
