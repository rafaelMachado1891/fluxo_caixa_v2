
WITH int_lancamentos AS (
    SELECT
        numero_titulo,
        serie,
        numero_da_parcela,
        tipo_pagamento,
        data_recebimento,
        valor,
        conta_contabil_credito,
        conta_contabil_debito,
        id_cliente,
        instituicao,
        data_lancamento
    FROM
        {{ ref('stg_lancamentos_fluxo') }}
),

tabela_tratada AS (
    SELECT
        numero_titulo,
        COALESCE(serie, 'S/N') AS serie,
        numero_da_parcela,
        CASE
            WHEN tipo_pagamento = 'D' THEN 'S'
            ELSE 'E'
        END AS tipo_pagamento,
        data_recebimento,
        valor,
        CASE
            WHEN conta_contabil_credito = 0 THEN conta_contabil_debito
            ELSE conta_contabil_credito
        END AS id_conta_contabil,
        id_cliente,
        instituicao,
        data_lancamento
    FROM 
        int_lancamentos
)

SELECT 
    numero_titulo,
    serie,
    numero_da_parcela,
    data_recebimento AS data_emissao,
    data_recebimento  AS vencimento,
    data_recebimento AS data_pagamento,
    valor AS valor_titulo,
    tipo_pagamento,
    instituicao,
    'PAGO':: TEXT AS situacao_titulo,
    CASE 
        WHEN id_conta_contabil = 0 THEN 9999
        ELSE id_conta_contabil END AS id_conta_contabil,
    id_cliente,
    data_lancamento
FROM tabela_tratada
