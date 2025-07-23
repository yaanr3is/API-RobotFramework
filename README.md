# 🚀 Projeto de Testes Automatizados

Este projeto contém testes automatizados utilizando Robot Framework e gerenciador de dependências `poetry`.

---

## ✅ Pré-requisitos

Antes de iniciar, certifique-se de que você tenha os seguintes itens instalados em seu sistema:

- [Python 3.11+](https://www.python.org/downloads/)
- [Poetry](https://python-poetry.org/docs/#installation)
- Git (opcional, para clonar o repositório)

Verifique as versões no terminal:
```bash
python3 --version
poetry --version
```


⚙️ Criando o ambiente virtual e instalando dependências

Com o poetry, não é necessário criar o ambiente virtual manualmente. Ele gerencia isso automaticamente.
1. Clone o repositório (se ainda não tiver feito)

git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio

2. Configure o Python correto no Poetry (ajuste se necessário)

poetry env use python3.11

    Substitua por python3.12 se estiver usando essa versão.

3. Instale as dependências

    poetry install

📁 Arquivo .env

Crie um arquivo .env na raiz do projeto com o seguinte conteúdo:

    API_ENVIRONMENT=DEV

Este arquivo é utilizado para configurar o ambiente em que os testes serão executados.
▶️ Executando os testes

Para entrar no ambiente virtual gerenciado pelo poetry:

    poetry shell 

Depois execute os testes com:

    robot tests/

Altere o caminho (tests/) conforme a estrutura do seu projeto.

🛠️ Dicas úteis

Para sair do ambiente virtual:

    exit
