WITH int_titulos AS (
    SELECT
        *
    FROM 
        {{ ref('stg_titulos') }}
),
tbl_titulos_transformada AS (
    SELECT 
        numero_titulo,
        COALESCE(serie, 'S/N') AS serie,
        numero_da_parcela,
        data_emissao,
        vencimento,
        data_pagamento,
        valor_titulo,
        tipo_pagamento,
        instituicao,
        CASE situacao_titulo
            WHEN 1 THEN 'PENDENTE'
            WHEN 2 THEN 'PARCIALMENTO_PAGO'
            WHEN 3 THEN 'PAGO'
            WHEN 4 THEN 'DEVOLVIDO'
            WHEN 5 THEN 'DEVOLVIDO_PARCIAL'
            WHEN 6 THEN 'CANCELADO'
            WHEN 7 THEN 'PENDENTE_NA_DATA'
            WHEN 8 THEN 'PARCIAL_PAGO'
            WHEN 9 THEN 'REVERSAO'
            ELSE 'OUTRO'
        END:: TEXT AS situacao_titulo,
        CASE WHEN
            conta_contabil_credito = 0 THEN conta_contabil_debito
            ELSE conta_contabil_credito END:: INTEGER AS id_conta_contabil,
        id_cliente,
        data_lancamento
    FROM int_titulos
)

SELECT 
    numero_titulo,
    serie,
    numero_da_parcela,
    data_emissao,
    vencimento,
    data_pagamento,
    valor_titulo,
    tipo_pagamento,
    instituicao,
    situacao_titulo,
    CASE WHEN 
        id_conta_contabil = 0 THEN 9999
        ELSE id_conta_contabil END AS id_conta_contabil,
    id_cliente,
    data_lancamento
FROM tbl_titulos_transformada