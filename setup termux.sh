#!/bin/bash

set -e

REPO_URL="https://github.com/jolodro/picocrafty.git"
DEFAULT_INSTALL_DIR="$HOME"

echo "📁 Onde deseja instalar o serviço?"
echo "➡️ Pressione ENTER para usar o padrão: $DEFAULT_INSTALL_DIR"
read -p "Caminho de instalação: $INSTALL_DIR" 

# Se o usuário não digitar nada, usa o padrão
INSTALL_DIR=${INSTALL_DIR:-$DEFAULT_INSTALL_DIR}

PROJECT_DIR="$INSTALL_DIR"

echo "📂 Diretório escolhido: $INSTALL_DIR"

# Criar diretório se não existir
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "📥 Clonando repositório..."
pkg install -y git
git clone "$REPO_URL"

echo "🐍 Instalando Python..."
pkg install -y python3
pip install --user virtualenv

cd "$PROJECT_DIR/picocrafty"

echo "🐍 Criando venv..."
python3 -m venv venv

echo "✅ Ativando venv..."
source venv/bin/activate

echo "⬆️ Atualizando pip..."
pip install --upgrade pip

echo "📦 Instalando dependências Python..."
pip install flask Flask-SQLAlchemy pyftpdlib requests psutil gunicorn

echo "☕ Instalando Java (OpenJDK 21)..."
pkg install -y openjdk-21

# -------------------------------
# CRIANDO O start.sh AUTOMATICAMENTE
# -------------------------------
echo "📝 Criando start.sh..."

cat << 'EOF' > start.sh
#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🐍 Ativando venv..."
source "$DIR/venv/bin/activate"

echo "🚀 Iniciando aplicação..."
gunicorn -c config.py "app:create_app()"
EOF

chmod +x start.sh

echo ""
echo "✅ Setup concluído com sucesso!"
echo "📂 Instalado em: $PROJECT_DIR"
echo "➡️ Para iniciar:"
echo "   cd $PROJECT_DIR"
echo "   ./start.sh"
