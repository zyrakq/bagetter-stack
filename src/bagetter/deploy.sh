#!/bin/bash

# BaGetter Deployment Script
# Simple script with predefined commands for easy copy-paste

show_help() {
    echo "BaGetter Deployment Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --production, -p     Use production configuration with access control"
    echo "  --letsencrypt, -l    Use Let's Encrypt certificates"
    echo "  --step-ca, -s        Use Step CA certificates"
    echo "  --forwarding, -f     Use port forwarding (development only)"
    echo "  --help, -h           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                   # Development with port forwarding"
    echo "  $0 -p -l             # Production with Let's Encrypt"
    echo "  $0 -p -s             # Production with Step CA"
    echo "  $0 -l                # Development with Let's Encrypt"
}

# Parse arguments
PRODUCTION=false
LETSENCRYPT=false
STEP_CA=false
FORWARDING=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --production|-p)
            PRODUCTION=true
            shift
            ;;
        --letsencrypt|-l)
            LETSENCRYPT=true
            shift
            ;;
        --step-ca|-s)
            STEP_CA=true
            shift
            ;;
        --forwarding|-f)
            FORWARDING=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Validate configuration
if [ "$PRODUCTION" = true ] && [ "$FORWARDING" = true ]; then
    echo "Error: Production mode cannot be used with port forwarding"
    echo "Use --help for valid combinations"
    exit 1
fi

# Default to forwarding if no certificate option specified and not production
if [ "$LETSENCRYPT" = false ] && [ "$STEP_CA" = false ] && [ "$FORWARDING" = false ]; then
    if [ "$PRODUCTION" = false ]; then
        FORWARDING=true
    else
        echo "Error: Production mode requires either --letsencrypt or --step-ca"
        echo "Use --help for valid combinations"
        exit 1
    fi
fi

# Select command based on configuration
if [ "$PRODUCTION" = true ] && [ "$LETSENCRYPT" = true ]; then
    # Production with Let's Encrypt
    docker-compose -f docker-compose.yml -f docker-compose.access.yml -f docker-compose.letsencrypt.yml up -d --build
elif [ "$PRODUCTION" = true ] && [ "$STEP_CA" = true ]; then
    # Production with Step CA
    docker-compose -f docker-compose.yml -f docker-compose.access.yml -f docker-compose.step-ca.yml up -d --build
elif [ "$PRODUCTION" = false ] && [ "$LETSENCRYPT" = true ]; then
    # Development with Let's Encrypt
    docker-compose -f docker-compose.yml -f docker-compose.letsencrypt.yml up -d --build
elif [ "$PRODUCTION" = false ] && [ "$STEP_CA" = true ]; then
    # Development with Step CA
    docker-compose -f docker-compose.yml -f docker-compose.step-ca.yml up -d --build
else
    # Development with port forwarding (default)
    docker-compose -f docker-compose.yml -f docker-compose.forwarding.yml up -d --build
fi