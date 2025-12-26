#!/bin/bash

set -e

REPO_URL="https://github.com/jolodro/picocrafty.git"
PROJECT_DIR="picocrafty"

echo "📥 Clonando repositório..."
pkg install git
git clone $REPO_URL

echo "Instalando python3..."
pkg install python3
pip install virtualenv

cd $PROJECT_DIR

echo "🐍 Criando venv..."
python3 -m venv venv

echo "✅ Ativando venv..."
source venv/bin/activate

echo "⬆️ Atualizando pip..."
pip install --upgrade pip

echo "📦 Instalando dependências Python..."
pip install flask Flask-SQLAlchemy pyftpdlib requests psutil

echo "☕ Instalando Java (OpenJDK 17)..."
pkg upgrade
pkg install -y openjdk-17

echo "☕ Instalando Java (OpenJDK 21)..."
pkg install -y openjdk-21

# -------------------------------
# CRIANDO O start.sh AUTOMATICAMENTE
# -------------------------------
echo "📝 Criando start.sh..."

cat << 'EOF' > start.sh
#!/bin/bash

echo "🐍 Ativando venv..."
source venv/bin/activate

echo "🚀 Iniciando aplicação..."
python run.py
EOF

chmod +x start.sh

echo "✅ Setup concluído com sucesso!"
echo "➡️ Inicie o projeto com: ./start.sh"
