#!/bin/bash
kompose convert -f docker-compose.yml
docker-compose down || true
docker-compose up --build
docker-compose logs chrome
