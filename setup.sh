#!/bin/bash

# Install Docker if not present
if ! command -v docker &> /dev/null
then
    echo "Docker not found. Please install Docker manually for your OS."
    exit 1
fi

# Install docker-compose if not present
if ! command -v docker-compose &> /dev/null
then
    echo "docker-compose not found. Installing..."
    # For Linux; adapt for your OS if needed
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Start the stack
docker-compose up -d

# Simple health checks
echo "Waiting for containers to start..."
sleep 10

echo "Checking app health:"
curl -s http://localhost:3000 || echo "App not reachable"

echo "Checking Jenkins health:"
curl -s http://localhost:8080 || echo "Jenkins not reachable"

echo "Checking Redis health:"
docker exec redis redis-cli ping || echo "Redis not reachable"

echo "Checking Nginx health:"
curl -s http://localhost/ || echo "Nginx not reachable"
