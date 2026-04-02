WITH saldo_inicial AS (
    SELECT 
        *
    FROM 
        {{ ref('int_saldo_inicial') }}
)

SELECT * FROM saldo_inicial