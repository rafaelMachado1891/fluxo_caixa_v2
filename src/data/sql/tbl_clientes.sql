SELECT 
  a.Codigo_C AS id_cliente,
  b.Razao AS razao
FROM Titulos a 
LEFT JOIN Terceiros b ON a.Codigo_C = b.Codigo
WHERE Data_Em > '2025-01-01' 
GROUP BY  
  a.Codigo_C,
  b.Razao,
  b.Atividade
