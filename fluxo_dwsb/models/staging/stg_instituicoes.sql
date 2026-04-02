WITH bancos AS (
    SELECT
        codigo,
        razao
    FROM 
    {{ source('fluxo_db', 'tbl_instituicoes') }}
),

tabela_transformada AS (
    SELECT 
        codigo:: INTEGER AS id_banco,
        razao:: TEXT AS razao_social
    FROM bancos
)

SELECT * FROM tabela_transformada



