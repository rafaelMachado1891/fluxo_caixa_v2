WITH clientes AS (
    SELECT 
        id_cliente,
        razao
    FROM 
        {{ source('fluxo_db', 'tbl_clientes') }}
),

tbl_tratada AS (
    SELECT
        id_cliente:: INTEGER AS id_cliente,
        razao:: TEXT AS razao_social
    FROM 
        clientes
)

SELECT * FROM tbl_tratada