import os
import sys
import subprocess
from dotenv import load_dotenv

# Carrega as variaveis do arquivo .env da raiz do projeto para o ambiente do sistema
env_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '.env'))
load_dotenv(env_path)

# Executa o comando dbt repassando os argumentos passados para o script
args = sys.argv[1:]
if not args:
    args = ["run"]

# Adiciona o diretório atual como fonte da configuração profiles.yml
dbt_exe = os.path.join(os.path.dirname(sys.executable), "dbt.exe")
cmd = [dbt_exe] + args + ["--profiles-dir", "."]

print(f"Executando dbt: {' '.join(cmd)}")
subprocess.run(cmd, cwd=os.path.dirname(__file__))
