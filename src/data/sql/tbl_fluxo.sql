WITH tb_titulos AS (
	SELECT 
		Numero AS numero_titulo,
		N AS n,
		Tipo_C AS tipo_credor,
		Serie  AS serie,
        Codigo_C AS id_cliente,
		Tipo_P AS tipo_pagamento,
		Data_Em AS data_emissao,
		Data_Ven AS vencimento,
		Data_pag AS data_pagamento,
		'''' + FORMAT(Valor_T, 'F2', 'en-US') AS valor_titulo,
		Instituicao AS instituicao,
		situacao AS situacao_titulo,
		ContaContabilCredito AS conta_contabil_credito,
		ContaContabilDebito AS conta_contabil_debito,
		CONCAT(Data_Inc, Hora_Inc) AS data_hora_lancamento
	FROM Titulos
	WHERE Data_Em > '2025-01-01'
),

tbl_conta_contabil AS (
	SELECT
		codigo AS codigo,
		Codigo_Conta AS codigo_conta,
		Descricao AS descricao
	FROM Conta_Contabil
),
tbl_terceiros AS (
SELECT
	id_cliente, 
	b.Razao AS razao,
	b.Atividade
FROM tb_titulos a
LEFT JOIN Terceiros b ON a.id_cliente = b.Codigo
),
resultado AS (
SELECT 
	a.numero_titulo,
	a.tipo_credor,
	a.serie,
	a.n,
	a.id_cliente,
	a.tipo_pagamento,
	a.data_emissao,
	a.vencimento,
	a.data_pagamento,
	a.valor_titulo,
	a.instituicao,
	a.situacao_titulo,
	b.codigo AS codigo_credito,
	b.descricao AS descricao_credito,
	c.codigo AS codigo_debito,
	c.descricao AS descricao_debito,
	a.data_hora_lancamento
FROM tb_titulos a
LEFT JOIN tbl_conta_contabil b
ON a.conta_contabil_credito = b.codigo 
LEFT JOIN tbl_conta_contabil c
ON a.conta_contabil_debito = c.codigo
)

SELECT * FROM resultado
