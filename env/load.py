import os
from robot.libraries.BuiltIn import BuiltIn
from dotenv import load_dotenv, dotenv_values

try:
    env = BuiltIn().get_variable_value('${ENVIRONMENT}')
except:
    env = None  # fallback para evitar erro no VSCode

# Limpar variáveis duplicadas
for key in dotenv_values().keys():
    if key in os.environ:
        del os.environ[key]

# Carregar .env
if env:
    env_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'env', f'{env.lower()}.env')
    load_dotenv(env_path)
else:
    load_dotenv()
