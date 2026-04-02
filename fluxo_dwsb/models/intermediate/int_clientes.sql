WITH int_clientes AS (
    SELECT
        *
    FROM 
        {{ ref('stg_clientes') }}
)

    SELECT 
     id_cliente,
     razao_social
    FROM 
        int_clientes