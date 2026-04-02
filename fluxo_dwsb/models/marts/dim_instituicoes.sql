WITH bancos AS (
    SELECT 
        *
    FROM 
        {{ ref('int_instituicoes') }}
)

SELECT 
    id_banco,
    razao_social
FROM bancos
