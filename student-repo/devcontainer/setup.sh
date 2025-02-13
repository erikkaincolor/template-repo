#!/bin/bash
set -e

echo "🚀 Setting up CSOS Development Environment..."

# Create necessary directories
mkdir -p ~/.local/bin
mkdir -p ~/.config/csos

# Install csosget tool
echo "📦 Installing csosget tool..."
curl -fsSL https://codestreamonlinestudios.com/csos-remote -o ~/.local/bin/csosget
chmod +x ~/.local/bin/csosget

# Add to PATH if not already there
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Install Python dependencies
echo "📚 Installing Python dependencies..."
python -m pip install --upgrade pip
pip install -r requirements.txt

# Configure git
echo "⚙️ Configuring git..."
git config --global pull.rebase false
git config --global core.editor "code --wait"

# Initialize csosget configuration
echo "🔧 Initializing csosget..."
csosget init || true

# Display welcome message
cat << 'EOF'
🎮 Welcome to your CSOS & VSCode Game Dev 2 Codespace! 

Quick Start. Open the VSCode terminal and type these commands:
1. Authenticate: csosget auth
2. List lessons: csosget list
3. Get a lesson: csosget get <lesson-name>

Need help? Type: csosget --help
EOF