WITH marts_clientes AS (
    SELECT 
        id_cliente, 
        razao_social
    FROM
        {{ ref('int_clientes') }}
)

SELECT * FROM marts_clientes