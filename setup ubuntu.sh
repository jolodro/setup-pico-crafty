#!/bin/bash

set -e

REPO_URL="https://github.com/jolodro/picocrafty.git"
PROJECT_DIR="picocrafty"

echo "📥 Clonando repositório..."
git clone $REPO_URL

cd $PROJECT_DIR

echo "Instalando virtualenv..."
pip install virtualenv

echo "🐍 Criando venv..."
python3 -m venv venv

echo "✅ Ativando venv..."
source venv/bin/activate

echo "⬆️ Atualizando pip..."
pip install --upgrade pip

echo "📦 Instalando dependências Python..."
pip install flask Flask-SQLAlchemy pyftpdlib requests psutil

echo "☕ Instalando Java (OpenJDK 17)..."
sudo apt update
sudo apt install -y openjdk-17-jre

echo "☕ Instalando Java (OpenJDK 21)..."
sudo apt install -y openjdk-21-jdk

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
