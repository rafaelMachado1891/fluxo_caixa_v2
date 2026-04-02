WITH plano_contas AS (
SELECT
    codigo,
    codigo_conta_contabil,
    conta_contabil,
    grupo_fluxo_caixa,
    natureza_fluxo,
    tipo_conta,
    recorrencia
FROM 
    {{ ref('int_plano_contas') }}
)

SELECT * FROM plano_contas