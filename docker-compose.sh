#!/bin/bash
kompose convert -f docker-compose.yml
docker-compose up --build
