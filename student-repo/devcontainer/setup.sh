#!/usr/bin/env python3
set -e

echo "🚀 Setting up CSOS Development Environment..."

# Create necessary directories
mkdir -p ~/.config/csos

# Install csosget tool in the GitHub Codespaces workspace directory
echo "📦 Installing csosget tool..."
curl -fsSL https://codestreamonlinestudios.com/csos-remote -o /workspaces/template-repo/student-repo/tools/csosget/csosget
chmod +x /workspaces/template-repo/student-repo/tools/csosget/csosget

# Add csosget tool to the PATH in the Codespace container
echo 'export PATH="/workspaces/template-repo/student-repo/tools/csosget:$PATH"' >> ~/.bashrc
source ~/.bashrc

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
