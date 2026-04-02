WITH lancamentos AS (
    SELECT 
        a.*,
        b.numero_titulo AS titulo_vinculado
    FROM 
        {{ ref('int_lancamentos_fluxo') }} a 
    LEFT JOIN
        {{ ref('int_titulos') }} b 
    ON a.numero_titulo = b.numero_titulo AND
       a.numero_titulo <> '0' AND
       a.numero_da_parcela = b.numero_da_parcela AND
       a.serie = b.serie AND
       a.id_cliente = b.id_cliente
    WHERE b.numero_titulo IS NULL

),

titulos AS (
    SELECT
        *,
        'TITULO_VINCULADO':: TEXT AS titulo_vinculado
    FROM 
        {{ ref('int_titulos') }}
),

consolidado AS (
    SELECT * FROM lancamentos
    UNION ALL
    SELECT * FROM titulos
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
    id_conta_contabil,
    id_cliente,
    CASE
        WHEN titulo_vinculado IS NULL THEN 'LANCAMENTO_AVULSO'
        ELSE 'TITULO_VINCULADO' END AS tipo_lancamento,
    CASE
        WHEN data_pagamento IS NULL THEN 'PROJETADO'
        ELSE 'REALIZADO' END AS tipo_fluxo

FROM consolidado


