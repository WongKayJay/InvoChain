#!/bin/bash

###############################################################################
# InvoChain Deployment Script
# Purpose: Automate deployment to g1t2.drshaiban.cloud
# Usage: ./deploy.sh [website|app|all]
###############################################################################

set -e  # Exit on error

# Configuration
SERVER="root@drshaiban.cloud"
REMOTE_DIR="/var/www/invochain"
LOCAL_WEBSITE_DIR="Website"
LOCAL_APP_DIR="Application/invochain_app/build/web"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

deploy_website() {
    print_info "Deploying marketing website..."
    
    # Check if website directory exists
    if [ ! -d "$LOCAL_WEBSITE_DIR" ]; then
        print_error "Website directory not found: $LOCAL_WEBSITE_DIR"
        exit 1
    fi
    
    # Deploy using rsync
    print_info "Syncing website files to server..."
    rsync -avz --progress --delete \
        --exclude '.git' \
        --exclude 'node_modules' \
        --exclude '.DS_Store' \
        "$LOCAL_WEBSITE_DIR/" "$SERVER:$REMOTE_DIR/website/"
    
    print_success "Website deployed successfully!"
}

deploy_app() {
    print_info "Deploying Flutter web application..."
    
    # Check if Flutter build exists
    if [ ! -d "$LOCAL_APP_DIR" ]; then
        print_error "Flutter build not found. Please run: flutter build web --release"
        print_info "Building Flutter app now..."
        
        cd Application/invochain_app
        flutter clean
        flutter pub get
        flutter build web --release --web-renderer html
        cd ../..
    fi
    
    # Deploy using rsync
    print_info "Syncing Flutter app to server..."
    rsync -avz --progress --delete \
        --exclude '.git' \
        "$LOCAL_APP_DIR/" "$SERVER:$REMOTE_DIR/app/"
    
    print_success "Flutter app deployed successfully!"
}

reload_nginx() {
    print_info "Reloading Nginx configuration..."
    ssh "$SERVER" "sudo nginx -t && sudo systemctl reload nginx"
    print_success "Nginx reloaded successfully!"
}

deploy_all() {
    print_info "Starting full deployment..."
    deploy_website
    deploy_app
    reload_nginx
    print_success "Full deployment completed!"
    print_info "Visit: https://g1t2.drshaiban.cloud"
}

show_usage() {
    echo "Usage: $0 [website|app|all]"
    echo ""
    echo "Options:"
    echo "  website  - Deploy marketing website only"
    echo "  app      - Deploy Flutter web application only"
    echo "  all      - Deploy everything (default)"
    echo ""
    echo "Examples:"
    echo "  $0 website"
    echo "  $0 app"
    echo "  $0 all"
}

# Main script
case "${1:-all}" in
    website)
        deploy_website
        reload_nginx
        ;;
    app)
        deploy_app
        reload_nginx
        ;;
    all)
        deploy_all
        ;;
    help|-h|--help)
        show_usage
        exit 0
        ;;
    *)
        print_error "Invalid option: $1"
        show_usage
        exit 1
        ;;
esac

print_success "Deployment process completed!"
echo ""
print_info "Next steps:"
echo "  1. Visit https://g1t2.drshaiban.cloud to verify website"
echo "  2. Visit https://g1t2.drshaiban.cloud/app to test Flutter app"
echo "  3. Check logs: ssh $SERVER 'sudo tail -f /var/log/nginx/invochain.access.log'"
