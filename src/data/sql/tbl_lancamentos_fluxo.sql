select 
Codigo,
tipo,
DataReceb,
descricao,
FORMAT(valor, 'F2' , 'en-US') AS VALOR,
NumTitulo,
Serie,
Instituicao,
ContaContabil,
ContaContabilDebito,
N,
Tipo_C,
Codigo_C
from FluxoCaixa 
where year(datareceb) = 2025
