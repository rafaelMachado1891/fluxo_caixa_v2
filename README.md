# fluxo_caixa_v2

Pipeline EL para ingestao de dados financeiros de um banco de origem para a camada RAW no banco de destino.

## Estrutura

- `src/pipeline.py`: ponto de entrada do processo
- `src/utils.py`: conexao com banco, leitura de SQL e carga dos dados
- `src/data/sql/`: coloque aqui os arquivos `.sql` de extracao
- `.env`: credenciais e configuracoes de execucao

## Como usar

1. Crie o arquivo `.env` a partir do `.env.example`
2. Adicione seus arquivos `.sql` em `src/data/sql/`
3. Rode o pipeline localmente com:

```bash
.venv\Scripts\python -m src.pipeline
```

Tambem funciona executar de dentro da pasta `src`:

```bash
..\.venv\Scripts\python.exe pipeline.py
```

Cada arquivo `.sql` sera executado e carregado no schema definido em `RAW_SCHEMA`, usando o nome do arquivo como nome da tabela.

## Variaveis principais

- Banco destino: `TARGET_DATABASE_URL`, `SCHEMA`
- Banco origem: `SOURCE_DB_HOST`, `SOURCE_DB_USER`, `SOURCE_DB_PASSWORD`, `SOURCE_DB_NAME`
- Controle do pipeline: `RAW_SCHEMA`, `SQL_DIR`, `WRITE_MODE`

## Supabase

Para usar Supabase como banco de destino, prefira uma URL completa com SSL:

```env
TARGET_DATABASE_URL="postgresql+psycopg2://postgres:SUA_SENHA@db.seu-projeto.supabase.co:5432/postgres?sslmode=require"
SCHEMA=public
RAW_SCHEMA=raw
```

Se voce quiser manter o formato antigo com `HOST`, `USER`, `PASSWORD`, `PORT` e `DBNAME`, o projeto ainda aceita essas variaveis. Nesse caso, defina `TARGET_DB_SSLMODE=require` para conexoes que exigem SSL.

## Banco de origem

O projeto agora aceita duas formas de configurar o banco de origem:

```env
SOURCE_DB_HOST=servidor_origem
SOURCE_DB_USER=usuario_origem
SOURCE_DB_PASSWORD=sua_senha_origem
SOURCE_DB_NAME=banco_origem
SOURCE_DB_DRIVER=ODBC Driver 17 for SQL Server
```

Ou, se preferir, voce ainda pode informar `DATABASE_URL` manualmente. A vantagem do formato acima e que o codigo faz o encoding correto da senha e evita erro quando houver caracteres especiais, como `@`.
