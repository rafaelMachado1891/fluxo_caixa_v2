
WITH lancamentos AS (
    SELECT 
        "NumTitulo",
        "Serie",
        "N",
        "tipo",
        "DataReceb",
        "valor",
        "ContaContabil",
        "ContaContabilDebito",
        "Tipo_C",
        "Codigo_C",
        "Instituicao"
    FROM {{ source('fluxo_db', 'tbl_lancamentos_fluxo') }}
),

tabela_tratada AS (
    SELECT
        "NumTitulo"::TEXT AS numero_titulo,
        "Serie"::TEXT AS serie,
        "N"::INTEGER AS numero_da_parcela,
        "tipo"::TEXT AS tipo_pagamento,
        "DataReceb"::DATE AS data_recebimento,
        REPLACE("valor"::TEXT, ',', '')::DECIMAL AS valor,
        "ContaContabil"::INTEGER AS conta_contabil_credito,
        "ContaContabilDebito"::INTEGER AS conta_contabil_debito,
        "Codigo_C"::INTEGER AS id_cliente,
        "Instituicao"::INTEGER AS instituicao,
        "DataReceb"::DATE AS data_lancamento
    FROM lancamentos
)

SELECT * FROM tabela_tratada
