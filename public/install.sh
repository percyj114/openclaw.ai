#!/bin/bash
set -e

# Clawdbot Installer for macOS and Linux
# Usage: curl -fsSL https://clawd.bot/install.sh | bash

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}${BOLD}"
echo "  🦞 Clawdbot Installer"
echo -e "${NC}"

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ -n "$WSL_DISTRO_NAME" ]]; then
    OS="linux"
fi

if [[ "$OS" == "unknown" ]]; then
    echo -e "${RED}Error: Unsupported operating system${NC}"
    echo "This installer supports macOS and Linux (including WSL)."
    echo "For Windows, use: iwr -useb https://clawd.bot/install.ps1 | iex"
    exit 1
fi

echo -e "${GREEN}✓${NC} Detected: $OS"

# Check for Homebrew on macOS
install_homebrew() {
    if [[ "$OS" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            echo -e "${YELLOW}→${NC} Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # Add Homebrew to PATH for this session
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
            echo -e "${GREEN}✓${NC} Homebrew installed"
        else
            echo -e "${GREEN}✓${NC} Homebrew already installed"
        fi
    fi
}

# Check Node.js version
check_node() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [[ "$NODE_VERSION" -ge 22 ]]; then
            echo -e "${GREEN}✓${NC} Node.js v$(node -v | cut -d'v' -f2) found"
            return 0
        else
            echo -e "${YELLOW}→${NC} Node.js $(node -v) found, but v22+ required"
            return 1
        fi
    else
        echo -e "${YELLOW}→${NC} Node.js not found"
        return 1
    fi
}

# Install Node.js
install_node() {
    if [[ "$OS" == "macos" ]]; then
        echo -e "${YELLOW}→${NC} Installing Node.js via Homebrew..."
        brew install node@22
        brew link node@22 --overwrite --force 2>/dev/null || true
        echo -e "${GREEN}✓${NC} Node.js installed"
    elif [[ "$OS" == "linux" ]]; then
        echo -e "${YELLOW}→${NC} Installing Node.js via NodeSource..."
        # Using NodeSource for latest Node.js
        if command -v apt-get &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
            sudo apt-get install -y nodejs
        elif command -v dnf &> /dev/null; then
            curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -
            sudo dnf install -y nodejs
        elif command -v yum &> /dev/null; then
            curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -
            sudo yum install -y nodejs
        else
            echo -e "${RED}Error: Could not detect package manager${NC}"
            echo "Please install Node.js 22+ manually: https://nodejs.org"
            exit 1
        fi
        echo -e "${GREEN}✓${NC} Node.js installed"
    fi
}

# Install Clawdbot
install_clawdbot() {
    echo -e "${YELLOW}→${NC} Installing Clawdbot..."
    npm install -g clawdbot@latest
    echo -e "${GREEN}✓${NC} Clawdbot installed"
}

# Main installation flow
main() {
    # Step 1: Homebrew (macOS only)
    install_homebrew

    # Step 2: Node.js
    if ! check_node; then
        install_node
    fi

    # Step 3: Clawdbot
    install_clawdbot

    echo ""
    echo -e "${GREEN}${BOLD}🦞 Clawdbot installed successfully!${NC}"
    echo ""
    echo -e "Run ${CYAN}clawdbot onboard${NC} to set up your assistant."
    echo ""

    # Ask to run onboard
    read -p "Start setup now? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        exec clawdbot onboard
    fi
}

main
