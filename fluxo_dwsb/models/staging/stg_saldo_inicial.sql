WITH saldo_inicial AS (
    SELECT 
        "DataMov",
        "Saldo"
    FROM 
        {{ source('fluxo_db', 'tbl_saldo_inicial') }}
),

saldo_tratada AS (
    SELECT
        "DataMov":: DATE AS data_inicial,
        REPLACE("Saldo", ',', '.'):: DECIMAL AS saldo
    FROM saldo_inicial
)

    SELECT * FROM saldo_tratada