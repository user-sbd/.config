#!/usr/bin/env zsh

# Advanced tmux session manager for macOS (zsh version)
# Features:
# - Scans ~/Documents, ~/.config (dots replaced with underscores), and neovim plugin directory
# - Clones GitHub repos if provided URL doesn't exist
# - Uses sk (skim) with custom styling and preview

# Configuration
DOCS_DIR="$HOME/Documents"
CONFIG_DIR="$HOME/.config"
NVIM_PLUGINS_DIR="$HOME/.local/share/nvim/site/pack/core/opt"
PROJECTS_DIR="$HOME/Documents/projects"
TMUX_SESSION_PREFIX="dev"

# Colors for output
autoload -U colors && colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Check if sk is installed
if ! command -v sk &> /dev/null; then
    print -P "${RED}Error: sk (skim) is not installed.${NC}"
    print -P "Install with: ${CYAN}brew install sk${NC}"
    exit 1
fi

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    print -P "${RED}Error: tmux is not installed.${NC}"
    exit 1
fi

# Function to get directories from a path
get_dirs() {
    local base_path="$1"
    local prefix="$2"
    
    if [[ -d "$base_path" ]]; then
        for dir in "$base_path"/*(/); do
            if [[ -d "$dir" ]]; then
                local dir_name="${dir:t}"
                print -n "${prefix}${dir_name}|${dir}\n"
            fi
        done
    fi
}

# Function to clone GitHub repository
clone_github_repo() {
    local url="$1"
    local repo_name="${url:t:r}"
    local target_dir="$PROJECTS_DIR/$repo_name"
    
    print -P "${BLUE}Cloning $url...${NC}"
    
    # Create projects directory if it doesn't exist
    mkdir -p "$PROJECTS_DIR"
    
    # Clone the repository
    if git clone "$url" "$target_dir" 2>/dev/null; then
        print -P "${GREEN}Successfully cloned to: $target_dir${NC}"
        print "$target_dir"
    else
        print -P "${RED}Failed to clone repository${NC}"
        return 1
    fi
}

# Function to create or attach to tmux session
create_tmux_session() {
    local session_name="$1"
    local working_dir="$2"
    
    # Clean session name (replace dots, spaces, etc.)
    session_name="${session_name//[^a-zA-Z0-9_-]/_}"
    
    # Check if session already exists
    if tmux has-session -t "$session_name" 2>/dev/null; then
        print -P "${YELLOW}Session already exists: $session_name${NC}"
        
        if [[ -n "$TMUX" ]]; then
            # Inside tmux, switch to existing session
            print -P "${BLUE}Switching to session within tmux...${NC}"
            tmux switch-client -t "$session_name"
        else
            # Outside tmux, attach to session
            tmux attach -t "$session_name"
        fi
    else
        print -P "${GREEN}Creating new session: $session_name${NC}"
        print -P "${CYAN}Working directory: $working_dir${NC}"
        
        # Create new session in the background
        tmux new-session -d -s "$session_name" -c "$working_dir"
        
        # Set window name to directory basename
        tmux rename-window -t "$session_name:0" "${working_dir:t}"
        
        # Add a second window for running commands
        tmux new-window -t "$session_name:1" -n "shell" -c "$working_dir"
        
        # Go back to first window
        tmux select-window -t "$session_name:0"
        
        if [[ -n "$TMUX" ]]; then
            # Already in tmux, switch to new session
            print -P "${BLUE}Switching to new session...${NC}"
            tmux switch-client -t "$session_name"
        else
            # Not in tmux, attach to new session
            tmux attach -t "$session_name"
        fi
    fi
}

# Function to check if string is a GitHub URL
is_github_url() {
    [[ "$1" =~ '^(https?://github\.com/|git@github\.com:).*\.git$' ]] || \
    [[ "$1" =~ '^(https?://github\.com/|git@github\.com:).*$' ]]
}

# Function to check if string is a local path
is_local_path() {
    [[ "$1" =~ '^/' ]] || [[ "$1" =~ '^\.' ]] || [[ "$1" =~ '^~' ]]
}

# Main function to collect directories and present selection
main() {
    print -P "${BOLD}${BLUE}=== tmux Session Manager ===${NC}"
    print -P "${CYAN}Scanning directories...${NC}"
    
    # Array to hold directory entries
    local -a dir_entries=()
    
    # Scan Documents directory
    if [[ -d "$DOCS_DIR" ]]; then
        for dir in "$DOCS_DIR"/*(/); do
            if [[ -d "$dir" ]]; then
                local dir_name="${dir:t}"
                dir_entries+=("docs_${dir_name}|${dir}")
            fi
        done
    fi
    
    # Scan .config directory (replace dots with underscores in display name)
    if [[ -d "$CONFIG_DIR" ]]; then
        for dir in "$CONFIG_DIR"/*(/); do
            if [[ -d "$dir" ]]; then
                local dir_name="${dir:t}"
                local display_name="${dir_name//./_}"
                dir_entries+=("config_${display_name}|${dir}")
            fi
        done
    fi
    
    # Scan nvim plugins directory
    if [[ -d "$NVIM_PLUGINS_DIR" ]]; then
        for dir in "$NVIM_PLUGINS_DIR"/*(/); do
            if [[ -d "$dir" ]]; then
                local dir_name="${dir:t}"
                dir_entries+=("nvim_${dir_name}|${dir}")
            fi
        done
    fi
    
    # Check if we have any directories
    if [[ ${#dir_entries[@]} -eq 0 ]]; then
        print -P "${YELLOW}No directories found in scanned locations.${NC}"
        print -P "You can enter a GitHub URL or local path."
    fi
    
    # Build header message
    local header_msg=""
    if [[ -n "$TMUX" ]]; then
        header_msg="Enter: ${GREEN}Select directory${NC} | ${CYAN}Type GitHub URL${NC}\n${BOLD}?${NC}: toggle preview | ${BOLD}Ctrl-C${NC}: exit\n${YELLOW}Already in tmux - will switch sessions${NC}"
    else
        header_msg="Enter: ${GREEN}Select directory${NC} | ${CYAN}Type GitHub URL${NC}\n${BOLD}?${NC}: toggle preview | ${BOLD}Ctrl-C${NC}: exit"
    fi
    
    # Present selection using sk
    local selection
    selection=$(printf "%s\n" "${dir_entries[@]}" | sk \
        --margin="10%" \
        --color="bw" \
        --prompt="📁 Select or type > " \
        --preview="ls -la \$(echo {} | cut -d'|' -f2) 2>/dev/null | head -30" \
        --preview-window="right:60%" \
        --bind="?:toggle-preview" \
        --bind="ctrl-c:abort" \
        --bind="ctrl-d:abort" \
        --header="$header_msg" \
        --print-query)
    
    # Check if selection was made
    if [[ $? -ne 0 ]]; then
        print -P "\n${YELLOW}Selection cancelled.${NC}"
        exit 0
    fi
    
    # Parse sk output (first line is query, second line is selection if any)
    local lines=(${(@f)selection})
    local user_input="${lines[1]}"
    local selected_entry="${lines[2]}"
    
    local working_dir
    local session_name
    
    # Determine what was selected/entered
    if [[ -n "$selected_entry" ]]; then
        # User selected from the list
        working_dir="${selected_entry#*|}"
        local display_name="${selected_entry%%|*}"
        session_name="${TMUX_SESSION_PREFIX}_${display_name}"
    elif [[ -n "$user_input" ]]; then
        # User typed something
        if is_github_url "$user_input"; then
            print -P "${BLUE}GitHub URL detected: $user_input${NC}"
            
            # Extract repo name from URL
            local repo_name="${user_input:t:r}"
            local target_dir="$PROJECTS_DIR/$repo_name"
            
            # Check if directory already exists
            if [[ -d "$target_dir" ]]; then
                print -P "${YELLOW}Directory already exists: $target_dir${NC}"
                working_dir="$target_dir"
            else
                # Clone the repository
                working_dir=$(clone_github_repo "$user_input")
                if [[ $? -ne 0 ]]; then
                    print -P "${RED}Failed to process GitHub URL${NC}"
                    exit 1
                fi
            fi
            
            # Create session name from repo name
            session_name="${TMUX_SESSION_PREFIX}_${repo_name//[^a-zA-Z0-9_-]/_}"
            
        elif is_local_path "$user_input"; then
            # Expand ~ and handle relative paths
            if [[ "$user_input" =~ '^~' ]]; then
                working_dir="${user_input/\~/$HOME}"
            elif [[ "$user_input" =~ '^\.' ]]; then
                working_dir="$(pwd)/${user_input#./}"
            else
                working_dir="$user_input"
            fi
            
            # Verify directory exists
            if [[ ! -d "$working_dir" ]]; then
                print -P "${RED}Directory does not exist: $working_dir${NC}"
                exit 1
            fi
            
            # Create session name from directory name
            session_name="${TMUX_SESSION_PREFIX}_${working_dir:t//[^a-zA-Z0-9_-]/_}"
            
        else
            # Treat as a new directory name in Projects
            local new_dir_name="${user_input//[^a-zA-Z0-9_-]/_}"
            working_dir="$PROJECTS_DIR/$new_dir_name"
            
            # Create directory if it doesn't exist
            if [[ ! -d "$working_dir" ]]; then
                mkdir -p "$working_dir"
                print -P "${GREEN}Created directory: $working_dir${NC}"
            fi
            
            session_name="${TMUX_SESSION_PREFIX}_${new_dir_name}"
        fi
    else
        print -P "${YELLOW}No input provided. Exiting.${NC}"
        exit 0
    fi
    
    # Verify directory exists
    if [[ ! -d "$working_dir" ]]; then
        print -P "${RED}Directory does not exist: $working_dir${NC}"
        exit 1
    fi
    
    # Create or attach to tmux session
    create_tmux_session "$session_name" "$working_dir"
}

# Function to list existing tmux sessions
list_sessions() {
    print -P "${BOLD}${BLUE}=== Existing tmux sessions ===${NC}"
    tmux list-sessions 2>/dev/null || print -P "${YELLOW}No active sessions${NC}"
}

# Function to kill a tmux session
kill_session() {
    list_sessions
    print -P "\n${CYAN}Select session to kill:${NC}"
    
    local session_to_kill
    session_to_kill=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | sk \
        --margin="10%" \
        --color="bw" \
        --prompt="💀 Kill session > " \
        --bind="ctrl-c:abort")
    
    if [[ -n "$session_to_kill" ]]; then
        print -P "${YELLOW}Killing session: $session_to_kill${NC}"
        tmux kill-session -t "$session_to_kill"
        print -P "${GREEN}Session killed.${NC}"
    else
        print -P "${YELLOW}No session selected.${NC}"
    fi
}

# Function to switch sessions within tmux
switch_session() {
    print -P "${BOLD}${BLUE}=== Switch tmux session ===${NC}"
    
    local session_to_switch
    session_to_switch=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | sk \
        --margin="10%" \
        --color="bw" \
        --prompt="🔄 Switch to > " \
        --bind="ctrl-c:abort")
    
    if [[ -n "$session_to_switch" ]]; then
        print -P "${GREEN}Switching to session: $session_to_switch${NC}"
        tmux switch-client -t "$session_to_switch"
    else
        print -P "${YELLOW}No session selected.${NC}"
    fi
}

# Parse command line arguments
case "${1:-}" in
    list|l)
        list_sessions
        exit 0
        ;;
    kill|k)
        kill_session
        exit 0
        ;;
    switch|s)
        switch_session
        exit 0
        ;;
    help|--help|-h)
        print -P "${BOLD}${CYAN}=== tmux Session Manager Help ===${NC}"
        print -P ""
        print -P "${BOLD}Usage:${NC} $0 [command]"
        print -P ""
        print -P "${BOLD}Commands:${NC}"
        print -P "  ${GREEN}(no command)${NC}    Launch interactive selector"
        print -P "  ${CYAN}list, l${NC}         List existing tmux sessions"
        print -P "  ${RED}kill, k${NC}         Kill a tmux session"
        print -P "  ${YELLOW}switch, s${NC}      Switch to existing session (from within tmux)"
        print -P "  ${BLUE}help, -h${NC}       Show this help message"
        print -P ""
        print -P "${BOLD}Features:${NC}"
        print -P "  • Scans ~/Documents, ~/.config, and neovim plugins"
        print -P "  • Clones GitHub repos when URL is entered"
        print -P "  • Accepts local paths (absolute or relative)"
        print -P "  • Creates new directories in ~/Documents/projects/"
        print -P "  • Uses sk with preview and custom styling"
        print -P "  • Creates tmux sessions with directory as PWD"
        print -P "  • ${BOLD}Automatically handles nested tmux sessions${NC}"
        print -P ""
        print -P "${BOLD}When already in tmux:${NC}"
        print -P "  • Will ${CYAN}switch${NC} to the selected session instead of nesting"
        print -P "  • Use ${YELLOW}sesh.sh switch${NC} to switch between existing sessions"
        print -P ""
        print -P "${BOLD}Shortcuts in selector:${NC}"
        print -P "  • ${CYAN}Enter${NC}: Select directory or use typed input"
        print -P "  • ${CYAN}?${NC}: Toggle preview pane"
        print -P "  • ${CYAN}Ctrl-C${NC}: Exit"
        exit 0
        ;;
    *)
        main
        ;;
esac
