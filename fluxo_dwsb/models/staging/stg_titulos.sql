WITH titulos AS (
    SELECT
        *
    FROM 
        {{ source('fluxo_db', 'tbl_fluxo') }}
),
tbl_titulos_transformada AS (
    SELECT 
        numero_titulo:: TEXT AS numero_titulo,
        serie:: TEXT AS serie,
        n:: INTEGER AS numero_da_parcela,
        data_emissao:: DATE AS data_emissao,
        vencimento:: DATE AS vencimento,
        data_pagamento:: DATE as data_pagamento,
        REPLACE(valor_titulo::TEXT, ',', '')::DECIMAL AS valor_titulo,
        CASE WHEN
            tipo_credor = 2 OR tipo_credor = 3 THEN 'S'
            ELSE 'E' END:: text AS tipo_pagamento,
        instituicao:: INTEGER AS instituicao,
        situacao_titulo:: INTEGER AS situacao_titulo,
        codigo_credito:: INTEGER AS conta_contabil_credito,
        codigo_debito:: INTEGER AS conta_contabil_debito,
        id_cliente:: INTEGER AS id_cliente,
        TO_DATE(SUBSTRING(data_hora_lancamento FROM '^[A-Za-z]{3} [0-9]{1,2} [0-9]{4}'), 'Mon DD YYYY') AS data_hora_lancamento
    FROM titulos
)

SELECT 
    numero_titulo,
    serie,
    numero_da_parcela,
    data_emissao,
    vencimento,
    CASE
        WHEN data_pagamento = '1753-01-01' THEN NULL
        ELSE data_pagamento
    END AS data_pagamento,
    valor_titulo,
    tipo_pagamento,
    CASE
        WHEN instituicao = '0' THEN 2
        ELSE instituicao
    END AS instituicao,
    situacao_titulo,
    COALESCE(conta_contabil_credito,0) AS conta_contabil_credito,
    COALESCE(conta_contabil_debito,0) AS conta_contabil_debito,
    id_cliente,
    data_hora_lancamento AS data_lancamento
FROM tbl_titulos_transformada
