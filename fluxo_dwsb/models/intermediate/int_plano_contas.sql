WITH plano_contas AS (
    SELECT
        codigo,
        codigo_conta_contabil,
        conta_contabil,
        data_inclusao
    FROM 
        {{ ref('stg_plano_contas') }}
),

contas_tratadas AS (
SELECT 
    *
FROM plano_contas

UNION ALL 

SELECT
    9999 AS codigo,
    '9999.1' AS codigo_conta_contabil,
    'NAO_INFORMADO' AS conta_contabil,
    CURRENT_DATE AS data_inclusao
),

plano_contas_estatico AS (
    SELECT 
        id_conta_contabil,
        grupo_fluxo_caixa,
        natureza_fluxo,
        tipo_conta,
        recorrencia
    FROM 
        {{ ref('categoria_contas') }}
),

resultado AS (
    SELECT 
        a.*,
        b.grupo_fluxo_caixa,
        b.natureza_fluxo,
        tipo_conta,
        recorrencia
    FROM 
        contas_tratadas a 
    LEFT JOIN 
        plano_contas_estatico b 
    ON a.codigo = b.id_conta_contabil
)

SELECT * FROM resultado