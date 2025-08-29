#!/bin/bash

# Clean color palette
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
BOLD='\033[1m'
NC='\033[0m'

# Clean header design
show_header() {
    clear
    echo ""
    echo -e "${BOLD}${CYAN}  GITHUB SSH SETUP  ${NC}"
    echo ""
    echo -e "${GRAY}  by Frank I. | linkedin.com/in/frankrevops${NC}"
    echo ""
    echo -e "${BOLD}What this app does:${NC}"
    echo "• Generates SSH keys for secure GitHub authentication"
    echo "• Adds keys to your SSH agent automatically"
    echo "• Copies public key to clipboard for easy GitHub setup"
    echo "• Tests your connection to verify everything works"
    echo ""
    echo -e "${GRAY}No more password prompts - just secure SSH connections!${NC}"
    echo ""
}

# Simple status indicators
show_status() {
    local status=$1
    local message=$2
    case $status in
        "info")
            echo -e "${BLUE}> INFO:${NC} ${message}"
            ;;
        "success")
            echo -e "${GREEN}✓ SUCCESS:${NC} ${message}"
            ;;
        "warning")
            echo -e "${YELLOW}! WARNING:${NC} ${message}"
            ;;
        "error")
            echo -e "${RED}✗ ERROR:${NC} ${message}"
            ;;
        "progress")
            echo -e "${CYAN}• WORKING:${NC} ${message}"
            ;;
    esac
}

# Simple progress display
show_progress() {
    local current=$1
    local total=$2
    local percentage=$((current * 100 / total))
    
    echo -e "${GRAY}  Step ${current}/${total} (${percentage}%)${NC}"
    echo ""
}

# Simple step display
show_step() {
    local step=$1
    local title=$2
    
    show_header
    show_progress $step 4
    
    echo -e "${BOLD}${WHITE}STEP ${step}: ${title}${NC}"
    echo ""
}

# Function to generate SSH key
generate_ssh_key() {
    show_step 1 "Generate SSH Key"
    
    while true; do
        echo -e "${BOLD}Enter your email address:${NC}"
        read -p "Email: " email
        
        if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            break
        else
            echo ""
            show_status "error" "Invalid email format! Try again."
            echo ""
        fi
    done
    
    echo ""
    show_status "progress" "Generating Ed25519 key..."
    
    if ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N "" > /dev/null 2>&1; then
        show_status "success" "Ed25519 key generated successfully!"
    else
        show_status "warning" "Falling back to RSA..."
        if ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa -N "" > /dev/null 2>&1; then
            show_status "success" "RSA key generated successfully!"
        else
            show_status "error" "Key generation failed completely!"
            exit 1
        fi
    fi
    
    sleep 2
}

# Function to add SSH key to SSH agent
add_ssh_to_agent() {
    show_step 2 "Add to SSH Agent"
    
    show_status "progress" "Starting SSH agent..."
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    
    if [ -f ~/.ssh/id_ed25519 ]; then
        ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1
        show_status "success" "Ed25519 key added to agent!"
    elif [ -f ~/.ssh/id_rsa ]; then
        ssh-add ~/.ssh/id_rsa > /dev/null 2>&1
        show_status "success" "RSA key added to agent!"
    else
        show_status "error" "No SSH key found to add!"
        exit 1
    fi
    
    sleep 2
}

# Function to copy and display key for GitHub
add_ssh_to_github() {
    show_step 3 "Add to GitHub"
    
    local key_file=""
    if [ -f ~/.ssh/id_ed25519.pub ]; then
        key_file="~/.ssh/id_ed25519.pub"
    elif [ -f ~/.ssh/id_rsa.pub ]; then
        key_file="~/.ssh/id_rsa.pub"
    else
        show_status "error" "No public key found!"
        exit 1
    fi
    
    show_status "progress" "Copying key to clipboard..."
    
    # Try different clipboard commands
    if command -v pbcopy >/dev/null 2>&1; then
        cat $key_file | pbcopy
        show_status "success" "Key copied to clipboard! (macOS)"
    elif command -v xclip >/dev/null 2>&1; then
        cat $key_file | xclip -selection clipboard
        show_status "success" "Key copied to clipboard! (Linux)"
    elif command -v clip >/dev/null 2>&1; then
        cat $key_file | clip
        show_status "success" "Key copied to clipboard! (Windows)"
    else
        show_status "warning" "Clipboard not available, showing key:"
        echo ""
        echo "$(cat $key_file)"
    fi
    
    echo ""
    echo -e "${BOLD}GitHub Setup Instructions:${NC}"
    echo "1. Go to github.com/settings/keys"
    echo "2. Click 'New SSH key'"
    echo "3. Add a title (e.g., 'My Computer')"
    echo "4. Paste the key (already copied!)"
    echo "5. Click 'Add SSH key'"
    
    echo ""
    read -p "Press [ENTER] when complete..."
}

# Function to test SSH connection to GitHub
test_ssh_connection() {
    show_step 4 "Test Connection"
    
    show_status "progress" "Testing GitHub SSH connection..."
    
    ssh_output=$(ssh -T git@github.com 2>&1)
    
    if echo "$ssh_output" | grep -q "successfully authenticated"; then
        echo ""
        echo -e "${GREEN}${BOLD}CONNECTION SUCCESSFUL!${NC}"
        echo "You're ready to use GitHub SSH!"
    else
        show_status "error" "Connection test failed!"
        echo ""
        echo "Debug output:"
        echo "${ssh_output}"
        echo ""
        echo -e "${BOLD}Troubleshooting tips:${NC}"
        echo "• Verify key was added to GitHub"
        echo "• Try: ssh -vT git@github.com"
        echo "• Check internet connection"
    fi
}

# Clean main menu
show_main_menu() {
    show_header
    
    echo -e "${BOLD}Select an option:${NC}"
    echo ""
    
    echo "1. Full Setup (Generate + Add + Test)"
    echo "2. Generate Key Only"
    echo "3. Add to SSH Agent"
    echo "4. Test Connection"
    echo "5. Show Public Key"
    echo "6. Exit"
    echo ""
    
    read -p "Choice [1-6]: " choice
}

# Function to show public key
show_public_key() {
    show_header
    
    echo -e "${BOLD}Your Public SSH Key:${NC}"
    echo ""
    
    if [ -f ~/.ssh/id_ed25519.pub ]; then
        echo -e "${GREEN}Ed25519 Key:${NC}"
        echo "$(cat ~/.ssh/id_ed25519.pub)"
    elif [ -f ~/.ssh/id_rsa.pub ]; then
        echo -e "${GREEN}RSA Key:${NC}"
        echo "$(cat ~/.ssh/id_rsa.pub)"
    else
        show_status "error" "No public key found!"
    fi
    
    echo ""
    read -p "Press [ENTER] to continue..."
}

# Completion screen
show_completion() {
    show_header
    
    echo -e "${GREEN}${BOLD}SETUP COMPLETE!${NC}"
    echo ""
    echo "✓ SSH key generated"
    echo "✓ Added to SSH agent"
    echo "✓ GitHub connection tested"
    echo ""
    echo -e "${BOLD}Ready to clone with SSH!${NC}"
    
    echo ""
    read -p "Press [ENTER] for main menu..."
}

# Main script execution
main() {
    while true; do
        show_main_menu
        
        case $choice in
            1)
                generate_ssh_key
                add_ssh_to_agent
                add_ssh_to_github
                test_ssh_connection
                show_completion
                ;;
            2)
                generate_ssh_key
                echo ""
                read -p "Press [ENTER] for main menu..."
                ;;
            3)
                add_ssh_to_agent
                echo ""
                read -p "Press [ENTER] for main menu..."
                ;;
            4)
                test_ssh_connection
                echo ""
                read -p "Press [ENTER] for main menu..."
                ;;
            5)
                show_public_key
                ;;
            6)
                show_header
                echo -e "${GREEN}Thanks for using Frank I SSH Setup!${NC}"
                echo "Now go build something amazing!"
                echo ""
                exit 0
                ;;
            *)
                echo ""
                show_status "error" "Invalid choice! Select 1-6 only."
                sleep 2
                ;;
        esac
    done
}

# Run the main function
main
