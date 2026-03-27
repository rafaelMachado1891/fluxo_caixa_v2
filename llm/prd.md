# PRD — Data Pipeline de Fluxo de Caixa

## 1. Visão Geral

Este projeto tem como objetivo desenvolver um pipeline de dados responsável por extrair dados financeiros de um banco de origem e carregá-los em um banco de destino.

Nesta primeira versão o pipeline seguirá a arquitetura **EL (Extract, Load)**.

As transformações de dados não fazem parte desta fase inicial e serão implementadas em versões futuras do projeto.

O pipeline será executado em ambiente containerizado utilizando Docker.

---

# 2. Objetivo da Versão Atual

Implementar um pipeline capaz de:

- Conectar ao banco de origem
- Executar queries SQL de extração
- Carregar os dados em um banco de destino
- Armazenar os dados na camada RAW
- Executar o pipeline utilizando Docker Compose

---

# 3. Arquitetura do Pipeline

Fluxo de dados:

Banco de Origem  
↓  
Query SQL  
↓  
Pandas DataFrame  
↓  
Carga no banco destino  
↓  
Tabela RAW

Nesta fase o pipeline executa apenas ingestão de dados.

---

# 4. Stack Tecnológica

Linguagem:

- Python 3.11+

Bibliotecas:

- pandas
- sqlalchemy
- python-dotenv

Containerização:

- Docker
- Docker Compose

Banco de dados:

- Banco de origem: configurável
- Banco de destino: banco relacional

---

# 5. Estrutura do Projeto

Estrutura inicial do projeto:

project-root

src/
data/
queries.sql

utils.py
pipeline.py

Dockerfile
docker-compose.yml

.env
requirements.txt

PRD.md
README.md


# 6. Descrição dos Componentes

## src/data/queries.sql

Arquivo responsável por armazenar as queries SQL utilizadas para extração dos dados.

Cada query representa um dataset que será ingerido pelo pipeline.

---

## src/utils.py

Arquivo responsável por conter classes utilitárias do pipeline.

Responsabilidades:

- criar conexão com banco de origem
- criar conexão com banco de destino
- executar queries SQL
- carregar DataFrames no banco destino

---

## src/pipeline.py

Arquivo responsável por executar o pipeline de ingestão de dados.

Funções principais:

1. carregar variáveis do `.env`
2. criar conexão com banco de origem
3. executar queries SQL
4. carregar resultado em DataFrame
5. enviar DataFrame para banco destino

Este arquivo representa o **ponto de entrada do pipeline**.

---

# 7. Variáveis de Ambiente

Todas as credenciais devem ser armazenadas no arquivo `.env`.

---

# 8. Execução com Docker

O pipeline deve rodar dentro de um container Docker.

O `docker-compose.yml` será responsável por:

- construir a imagem do projeto
- carregar variáveis do `.env`
- executar o pipeline

Execução esperada:


docker compose up --build


---

# 9. Fluxo de Execução

Passos executados pelo pipeline:

1. carregar variáveis de ambiente
2. criar conexão com banco de origem
3. executar queries SQL de extração
4. carregar resultado em DataFrame
5. enviar dados para banco destino
6. persistir dados na camada RAW

---

# 10. Critérios de Sucesso

A implementação será considerada concluída quando:

- o pipeline conseguir extrair dados do banco de origem
- os dados forem carregados no banco destino
- o pipeline rodar corretamente dentro de um container Docker
- a execução puder ser realizada via docker-compose