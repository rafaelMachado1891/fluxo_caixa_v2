WITH int_instituicoes AS (
    SELECT
        id_banco,
        razao_social
    FROM 
        {{ ref('stg_instituicoes') }}
)

SELECT * FROM int_instituicoes