#!/bin/bash
set -e
trap '' PIPE  # Ignore SIGPIPE to avoid confusing "Unexpected SIGPIPE" errors from VS Code

# Set SSH password for remote access (port 2222)
echo 'vscode:devcontainer' | sudo chpasswd
echo "SSH password set (user: vscode, password: devcontainer)"

# Configure Starship prompt
mkdir -p ~/.config
# Custom Gruvbox-style config without Nerd Fonts
cp .devcontainer/starship.toml ~/.config/starship.toml
# Alternative presets (uncomment to use instead):
#starship preset plain-text-symbols -o ~/.config/starship.toml  # pure ASCII
#starship preset bracketed-segments -o ~/.config/starship.toml  # works with any font
#starship preset gruvbox-rainbow -o ~/.config/starship.toml     # requires Nerd Font
# Ensure starship init is in .zshrc (for SSH sessions)
if ! grep -q 'eval "$(starship init zsh)"' /home/vscode/.zshrc 2>/dev/null; then
    echo '' >> /home/vscode/.zshrc
    echo '# Starship prompt' >> /home/vscode/.zshrc
    echo 'eval "$(starship init zsh)"' >> /home/vscode/.zshrc
fi
echo "Configured Starship prompt"

# Ensure we have permissions to install global npm packages
sudo chown -R $(whoami) /usr/local/share/nvm

# Install Claude Code CLI globally
sudo mkdir -p ~/.claude
npm install -g @anthropic-ai/claude-code
sudo chown vscode:vscode ~/.claude
echo "Installed Claude Code CLI"

# Install Gemini CLI globally
#sudo mkdir -p ~/.gemini
#npm install -g @google/gemini-cli
#sudo chown vscode:vscode ~/.gemini
#echo "Installed Gemini CLI"

# Install OpenAI Codex CLI globally
#sudo mkdir -p ~/.codex
#npm install -g @openai/codex
#sudo chown vscode:vscode ~/.codex
#echo "Installed Codex CLI"

# Install GitHub Copilot CLI globally
sudo mkdir -p ~/.copilot
npm install -g @github/copilot
sudo chown vscode:vscode ~/.copilot
echo "Installed GitHub Copilot CLI"

# Add aliases to .zshrc if not already present
if ! grep -q "alias yolo-cl=" /home/vscode/.zshrc 2>/dev/null; then
    echo "" >> /home/vscode/.zshrc
    echo "# Claude Code YOLO alias" >> /home/vscode/.zshrc
    echo 'alias yolo-cl="claude --dangerously-skip-permissions"' >> /home/vscode/.zshrc
    echo "Added yolo-cl alias to .zshrc"
fi
if ! grep -q "alias yolo-co=" /home/vscode/.zshrc 2>/dev/null; then
    echo "" >> /home/vscode/.zshrc
    echo "# GitHub Copilot CLI YOLO alias with workspace MCP config" >> /home/vscode/.zshrc
    echo 'alias yolo-co="copilot --allow-all-tools --allow-all-paths --additional-mcp-config @.copilot/mcp-config.json"' >> /home/vscode/.zshrc
    echo 'alias copilot-mcps="copilot --additional-mcp-config @.copilot/mcp-config.json"' >> /home/vscode/.zshrc
    echo "Added yolo-co alias to .zshrc"
fi
if ! grep -q "alias specify=" /home/vscode/.zshrc 2>/dev/null; then
    echo "" >> /home/vscode/.zshrc
    echo "# Specify alias" >> /home/vscode/.zshrc
    echo 'alias specify="uvx --from git+https://github.com/github/spec-kit.git specify"' >> /home/vscode/.zshrc
    echo "Added specify alias to .zshrc"
fi

# Install todo-app dependencies
cd todo-app && uv sync && cd ..
echo "Installed todo-app dependencies"

# Display completion banner
echo ""
echo -e "\033[1;42;97m                                                                \033[0m"
echo -e "\033[1;42;97m   ✅  DEV CONTAINER READY!                                     \033[0m"
echo -e "\033[1;42;97m                                                                \033[0m"
echo -e "\033[1;32m╔════════════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;32m║  Available: python, node, deno, java, copilot, claude, gh  ║\033[0m"
echo -e "\033[1;32m║  Run 'copilot' to start GitHub Copilot CLI                 ║\033[0m"
echo -e "\033[1;32m╚════════════════════════════════════════════════════════════╝\033[0m"
echo ""
