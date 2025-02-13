#!/usr/bin/env python3
set -e

echo "🚀 Setting up CSOS Development Environment..."

# Create necessary directories
mkdir -p ~/.config/csos

# Install csosget tool in the GitHub Codespaces workspace directory
echo "📦 Installing csosget tool..."
chmod +x /workspaces/template-repo/student-repo/tools/csosget/csosget

# Create a symlink for csosget command in the PATH
echo "📂 Creating symlink for csosget command..."
ln -s /workspaces/template-repo/student-repo/tools/csosget/csosget /usr/local/bin/csosget

# Add /usr/local/bin to PATH in the Codespace container
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
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
