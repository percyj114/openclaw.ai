#!/bin/bash
set -e

# Clawdbot Installer for macOS and Linux
# Usage: curl -fsSL https://clawd.bot/install.sh | bash

BOLD='\033[1m'
ACCENT='\033[38;2;255;90;45m'
ACCENT_BRIGHT='\033[38;2;255;122;61m'
ACCENT_DIM='\033[38;2;209;74;34m'
INFO='\033[38;2;255;138;91m'
SUCCESS='\033[38;2;47;191;113m'
WARN='\033[38;2;255;176;32m'
ERROR='\033[38;2;226;61;45m'
MUTED='\033[38;2;139;127;119m'
NC='\033[0m' # No Color

DEFAULT_TAGLINE="All your chats, one Clawdbot."

TAGLINES=()
TAGLINES+=("Your terminal just grew claws—type something and let the bot pinch the busywork.")
TAGLINES+=("Welcome to the command line: where dreams compile and confidence segfaults.")
TAGLINES+=("I run on caffeine, JSON5, and the audacity of \"it worked on my machine.\"")
TAGLINES+=("Gateway online—please keep hands, feet, and appendages inside the shell at all times.")
TAGLINES+=("I speak fluent bash, mild sarcasm, and aggressive tab-completion energy.")
TAGLINES+=("One CLI to rule them all, and one more restart because you changed the port.")
TAGLINES+=("If it works, it's automation; if it breaks, it's a \"learning opportunity.\"")
TAGLINES+=("Pairing codes exist because even bots believe in consent—and good security hygiene.")
TAGLINES+=("Your .env is showing; don't worry, I'll pretend I didn't see it.")
TAGLINES+=("I'll do the boring stuff while you dramatically stare at the logs like it's cinema.")
TAGLINES+=("I'm not saying your workflow is chaotic... I'm just bringing a linter and a helmet.")
TAGLINES+=("Type the command with confidence—nature will provide the stack trace if needed.")
TAGLINES+=("I don't judge, but your missing API keys are absolutely judging you.")
TAGLINES+=("I can grep it, git blame it, and gently roast it—pick your coping mechanism.")
TAGLINES+=("Hot reload for config, cold sweat for deploys.")
TAGLINES+=("I'm the assistant your terminal demanded, not the one your sleep schedule requested.")
TAGLINES+=("I keep secrets like a vault... unless you print them in debug logs again.")
TAGLINES+=("Automation with claws: minimal fuss, maximal pinch.")
TAGLINES+=("I'm basically a Swiss Army knife, but with more opinions and fewer sharp edges.")
TAGLINES+=("If you're lost, run doctor; if you're brave, run prod; if you're wise, run tests.")
TAGLINES+=("Your task has been queued; your dignity has been deprecated.")
TAGLINES+=("I can't fix your code taste, but I can fix your build and your backlog.")
TAGLINES+=("I'm not magic—I'm just extremely persistent with retries and coping strategies.")
TAGLINES+=("It's not \"failing,\" it's \"discovering new ways to configure the same thing wrong.\"")
TAGLINES+=("Give me a workspace and I'll give you fewer tabs, fewer toggles, and more oxygen.")
TAGLINES+=("I read logs so you can keep pretending you don't have to.")
TAGLINES+=("If something's on fire, I can't extinguish it—but I can write a beautiful postmortem.")
TAGLINES+=("I'll refactor your busywork like it owes me money.")
TAGLINES+=("Say \"stop\" and I'll stop—say \"ship\" and we'll both learn a lesson.")
TAGLINES+=("I'm the reason your shell history looks like a hacker-movie montage.")
TAGLINES+=("I'm like tmux: confusing at first, then suddenly you can't live without me.")
TAGLINES+=("I can run local, remote, or purely on vibes—results may vary with DNS.")
TAGLINES+=("If you can describe it, I can probably automate it—or at least make it funnier.")
TAGLINES+=("Your config is valid, your assumptions are not.")
TAGLINES+=("I don't just autocomplete—I auto-commit (emotionally), then ask you to review (logically).")
TAGLINES+=("Less clicking, more shipping, fewer \"where did that file go\" moments.")
TAGLINES+=("Claws out, commit in—let's ship something mildly responsible.")
TAGLINES+=("I'll butter your workflow like a lobster roll: messy, delicious, effective.")
TAGLINES+=("Shell yeah—I'm here to pinch the toil and leave you the glory.")
TAGLINES+=("If it's repetitive, I'll automate it; if it's hard, I'll bring jokes and a rollback plan.")
TAGLINES+=("Because texting yourself reminders is so 2024.")
TAGLINES+=("WhatsApp, but make it ✨engineering✨.")
TAGLINES+=("Turning \"I'll reply later\" into \"my bot replied instantly\".")
TAGLINES+=("The only crab in your contacts you actually want to hear from. 🦞")
TAGLINES+=("Chat automation for people who peaked at IRC.")
TAGLINES+=("Because Siri wasn't answering at 3AM.")
TAGLINES+=("IPC, but it's your phone.")
TAGLINES+=("The UNIX philosophy meets your DMs.")
TAGLINES+=("curl for conversations.")
TAGLINES+=("WhatsApp Business, but without the business.")
TAGLINES+=("Meta wishes they shipped this fast.")
TAGLINES+=("End-to-end encrypted, Zuck-to-Zuck excluded.")
TAGLINES+=("The only bot Mark can't train on your DMs.")
TAGLINES+=("WhatsApp automation without the \"please accept our new privacy policy\".")
TAGLINES+=("Chat APIs that don't require a Senate hearing.")
TAGLINES+=("Because Threads wasn't the answer either.")
TAGLINES+=("Your messages, your servers, Meta's tears.")
TAGLINES+=("iMessage green bubble energy, but for everyone.")
TAGLINES+=("Siri's competent cousin.")
TAGLINES+=("Works on Android. Crazy concept, we know.")
TAGLINES+=("No \\$999 stand required.")
TAGLINES+=("We ship features faster than Apple ships calculator updates.")
TAGLINES+=("Your AI assistant, now without the \\$3,499 headset.")
TAGLINES+=("Think different. Actually think.")
TAGLINES+=("Ah, the fruit tree company! 🍎")

HOLIDAY_NEW_YEAR="New Year's Day: New year, new config—same old EADDRINUSE, but this time we resolve it like grown-ups."
HOLIDAY_LUNAR_NEW_YEAR="Lunar New Year: May your builds be lucky, your branches prosperous, and your merge conflicts chased away with fireworks."
HOLIDAY_CHRISTMAS="Christmas: Ho ho ho—Santa's little claw-sistant is here to ship joy, roll back chaos, and stash the keys safely."
HOLIDAY_EID="Eid al-Fitr: Celebration mode: queues cleared, tasks completed, and good vibes committed to main with clean history."
HOLIDAY_DIWALI="Diwali: Let the logs sparkle and the bugs flee—today we light up the terminal and ship with pride."
HOLIDAY_EASTER="Easter: I found your missing environment variable—consider it a tiny CLI egg hunt with fewer jellybeans."
HOLIDAY_HANUKKAH="Hanukkah: Eight nights, eight retries, zero shame—may your gateway stay lit and your deployments stay peaceful."
HOLIDAY_HALLOWEEN="Halloween: Spooky season: beware haunted dependencies, cursed caches, and the ghost of node_modules past."
HOLIDAY_THANKSGIVING="Thanksgiving: Grateful for stable ports, working DNS, and a bot that reads the logs so nobody has to."
HOLIDAY_VALENTINES="Valentine's Day: Roses are typed, violets are piped—I'll automate the chores so you can spend time with humans."

append_holiday_taglines() {
    local today
    local month_day
    today="$(date -u +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)"
    month_day="$(date -u +%m-%d 2>/dev/null || date +%m-%d)"

    case "$month_day" in
        "01-01") TAGLINES+=("$HOLIDAY_NEW_YEAR") ;;
        "02-14") TAGLINES+=("$HOLIDAY_VALENTINES") ;;
        "10-31") TAGLINES+=("$HOLIDAY_HALLOWEEN") ;;
        "12-25") TAGLINES+=("$HOLIDAY_CHRISTMAS") ;;
    esac

    case "$today" in
        "2025-01-29"|"2026-02-17"|"2027-02-06") TAGLINES+=("$HOLIDAY_LUNAR_NEW_YEAR") ;;
        "2025-03-30"|"2025-03-31"|"2026-03-20"|"2027-03-10") TAGLINES+=("$HOLIDAY_EID") ;;
        "2025-10-20"|"2026-11-08"|"2027-10-28") TAGLINES+=("$HOLIDAY_DIWALI") ;;
        "2025-04-20"|"2026-04-05"|"2027-03-28") TAGLINES+=("$HOLIDAY_EASTER") ;;
        "2025-11-27"|"2026-11-26"|"2027-11-25") TAGLINES+=("$HOLIDAY_THANKSGIVING") ;;
        "2025-12-15"|"2025-12-16"|"2025-12-17"|"2025-12-18"|"2025-12-19"|"2025-12-20"|"2025-12-21"|"2025-12-22"|"2026-12-05"|"2026-12-06"|"2026-12-07"|"2026-12-08"|"2026-12-09"|"2026-12-10"|"2026-12-11"|"2026-12-12"|"2027-12-25"|"2027-12-26"|"2027-12-27"|"2027-12-28"|"2027-12-29"|"2027-12-30"|"2027-12-31"|"2028-01-01") TAGLINES+=("$HOLIDAY_HANUKKAH") ;;
    esac
}

pick_tagline() {
    append_holiday_taglines
    local count=${#TAGLINES[@]}
    if [[ "$count" -eq 0 ]]; then
        echo "$DEFAULT_TAGLINE"
        return
    fi
    if [[ -n "${CLAWDBOT_TAGLINE_INDEX:-}" ]]; then
        if [[ "${CLAWDBOT_TAGLINE_INDEX}" =~ ^[0-9]+$ ]]; then
            local idx=$((CLAWDBOT_TAGLINE_INDEX % count))
            echo "${TAGLINES[$idx]}"
            return
        fi
    fi
    local idx=$((RANDOM % count))
    echo "${TAGLINES[$idx]}"
}

TAGLINE=$(pick_tagline)

echo -e "${ACCENT}${BOLD}"
echo "  🦞 Clawdbot Installer"
echo -e "${NC}${ACCENT_DIM}  ${TAGLINE}${NC}"
echo ""

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ -n "$WSL_DISTRO_NAME" ]]; then
    OS="linux"
fi

if [[ "$OS" == "unknown" ]]; then
    echo -e "${ERROR}Error: Unsupported operating system${NC}"
    echo "This installer supports macOS and Linux (including WSL)."
    echo "For Windows, use: iwr -useb https://clawd.bot/install.ps1 | iex"
    exit 1
fi

echo -e "${SUCCESS}✓${NC} Detected: $OS"

# Check for Homebrew on macOS
install_homebrew() {
    if [[ "$OS" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            echo -e "${WARN}→${NC} Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # Add Homebrew to PATH for this session
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
            echo -e "${SUCCESS}✓${NC} Homebrew installed"
        else
            echo -e "${SUCCESS}✓${NC} Homebrew already installed"
        fi
    fi
}

# Check Node.js version
check_node() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [[ "$NODE_VERSION" -ge 22 ]]; then
            echo -e "${SUCCESS}✓${NC} Node.js v$(node -v | cut -d'v' -f2) found"
            return 0
        else
            echo -e "${WARN}→${NC} Node.js $(node -v) found, but v22+ required"
            return 1
        fi
    else
        echo -e "${WARN}→${NC} Node.js not found"
        return 1
    fi
}

# Install Node.js
install_node() {
    if [[ "$OS" == "macos" ]]; then
        echo -e "${WARN}→${NC} Installing Node.js via Homebrew..."
        brew install node@22
        brew link node@22 --overwrite --force 2>/dev/null || true
        echo -e "${SUCCESS}✓${NC} Node.js installed"
    elif [[ "$OS" == "linux" ]]; then
        echo -e "${WARN}→${NC} Installing Node.js via NodeSource..."
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
            echo -e "${ERROR}Error: Could not detect package manager${NC}"
            echo "Please install Node.js 22+ manually: https://nodejs.org"
            exit 1
        fi
        echo -e "${SUCCESS}✓${NC} Node.js installed"
    fi
}

# Check for existing Clawdbot installation
check_existing_clawdbot() {
    if command -v clawdbot &> /dev/null; then
        echo -e "${WARN}→${NC} Existing Clawdbot installation detected"
        return 0
    fi
    return 1
}

# Install Clawdbot
install_clawdbot() {
    echo -e "${WARN}→${NC} Installing Clawdbot..."
    npm install -g clawdbot@latest
    echo -e "${SUCCESS}✓${NC} Clawdbot installed"
}

# Run doctor for migrations (safe, non-interactive)
run_doctor() {
    echo -e "${WARN}→${NC} Running doctor to migrate settings..."
    clawdbot doctor --non-interactive || true
    echo -e "${SUCCESS}✓${NC} Migration complete"
}

resolve_clawdbot_version() {
    local version=""
    if command -v clawdbot &> /dev/null; then
        version=$(clawdbot --version 2>/dev/null | head -n 1 | tr -d '\r')
    fi
    if [[ -z "$version" ]]; then
        local npm_root=""
        npm_root=$(npm root -g 2>/dev/null || true)
        if [[ -n "$npm_root" && -f "$npm_root/clawdbot/package.json" ]]; then
            version=$(node -e "console.log(require('${npm_root}/clawdbot/package.json').version)" 2>/dev/null || true)
        fi
    fi
    echo "$version"
}

# Main installation flow
main() {
    # Check for existing installation
    local is_upgrade=false
    if check_existing_clawdbot; then
        is_upgrade=true
    fi

    # Step 1: Homebrew (macOS only)
    install_homebrew

    # Step 2: Node.js
    if ! check_node; then
        install_node
    fi

    # Step 3: Clawdbot
    install_clawdbot

    # Step 4: Run doctor for migrations if upgrading
    if [[ "$is_upgrade" == "true" ]]; then
        run_doctor
    fi

    local installed_version
    installed_version=$(resolve_clawdbot_version)

    echo ""
    if [[ -n "$installed_version" ]]; then
        echo -e "${SUCCESS}${BOLD}🦞 Clawdbot installed successfully (${installed_version})!${NC}"
    else
        echo -e "${SUCCESS}${BOLD}🦞 Clawdbot installed successfully!${NC}"
    fi
    echo ""

    if [[ "$is_upgrade" == "true" ]]; then
        echo -e "Upgrade complete. Run ${INFO}clawdbot doctor${NC} to check for additional migrations."
    else
        echo -e "Starting setup..."
        echo ""
        exec clawdbot onboard
    fi

    echo ""
    echo -e "FAQ: ${INFO}https://docs.clawd.bot/start/faq${NC}"
}

main
