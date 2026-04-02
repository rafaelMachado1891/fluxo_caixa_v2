WITH saldo AS (
    SELECT 
        data_inicial,
        saldo
    FROM
        {{ ref('stg_saldo_inicial') }}
)

    SELECT * FROM saldo