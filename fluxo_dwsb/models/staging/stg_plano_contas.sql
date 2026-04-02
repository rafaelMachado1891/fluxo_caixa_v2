WITH plano_contas AS (
    SELECT 
        codigo,
        codigo_conta,
        descricao,
        "DataInclusao"
    FROM 
        {{ source('fluxo_db', 'tbl_plano_contas') }}
),
contas_tratadas AS (
    SELECT
        codigo:: INTEGER AS codigo,
        codigo_conta:: TEXT AS codigo_conta_contabil,
        descricao:: TEXT AS conta_contabil,
        "DataInclusao":: DATE AS data_inclusao
    FROM plano_contas
)

SELECT 
  codigo,
  codigo_conta_contabil,
  conta_contabil,
  data_inclusao
FROM contas_tratadas
