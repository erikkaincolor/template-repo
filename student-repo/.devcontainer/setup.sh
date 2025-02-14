#!/usr/bin/env python3
set -e
echo "Starting setup.sh"
echo "Current directory: $(pwd)"
echo "Contents of current directory:"
ls -la
echo "🚀 Setting up CSOS Development Environment..."

# Create necessary directories
mkdir -p ~/.config/csos

# Install csosget in the GitHub Codespaces workspace directory
echo "📦 Installing csosget..."
if [ -f "/workspaces/template-repo/student-repo/tools/csos/csosget" ]; then
    chmod -v +x /workspaces/template-repo/student-repo/tools/csos/csosget
else
    echo "❌ csosget not found!"
fi

# Ensure csosget is in PATH without requiring a symlink
echo 'export PATH="/workspaces/template-repo/student-repo/tools/csos:$PATH"' >> ~/.bashrc
echo 'export PATH="/workspaces/template-repo/student-repo/tools/csos:$PATH"' >> ~/.bash_profile

# Apply changes immediately for the current session
export PATH="/workspaces/template-repo/student-repo/tools/csos:$PATH"
source ~/.bashrc || source ~/.bash_profile

# Install Python dependencies
echo "📚 Installing Python dependencies..."
python3 -m pip install --upgrade pip
pip install -r requirements.txt

# Configure git
echo "⚙️ Configuring git..."
git config --global pull.rebase false
git config --global core.editor "code --wait"

# Initialize csosget configuration
echo " Initializing csosget..."
csosget init || true

# Display welcome message
cat << 'EOF'
Welcome to your CSOS & VSCode Game Dev 2 Codespace! 

Quick Start. Open the VSCode terminal and type these commands:
1. Authenticate: csosget auth
2. List lessons: csosget list
3. Get a lesson: csosget get <lesson-name>

Need help? Type: csosget --help
EOF

echo "Attempting to chmod csosget"
chmod -v +x /workspaces/template-repo/student-repo/tools/csos/csosget
echo "chmod result: $?"

echo "Finished setup.sh"