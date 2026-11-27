-- =====================================================================
-- PROJETO: Precos de combustiveis no Brasil (ANP), jan/2023 a jun/2026
-- ARQUIVO: 03b_consultas_extras.sql  (banco: combustiveis)
--
-- COMO USAR: selecione UM bloco (do titulo ate o ponto e virgula),
-- aperte F5 e veja o resultado em "Data Output". Nao apague nada.
-- =====================================================================


-- =====================================================================
-- 5.5b  PERGUNTA 5 (versao robusta) - variacao de preco dentro do municipio
--       gasolina, ultimos 12 meses, sem precos atipicos
--       mede a faixa entre o posto "barato" (percentil 10) e o "caro"
--       (percentil 90): nao depende de um unico posto extremo.
--       so municipios com 10 postos ou mais
-- =====================================================================
WITH preco_posto AS (
    SELECT p.uf, p.municipio, f.cnpj,
           AVG(f.valor_venda) AS preco_posto
    FROM fato_preco f
    JOIN dim_posto p ON p.cnpj = f.cnpj
    WHERE f.produto = 'gasolina'
      AND NOT f.preco_atipico
      AND f.data_coleta > (SELECT MAX(data_coleta) FROM fato_preco) - INTERVAL '12 months'
    GROUP BY p.uf, p.municipio, f.cnpj
)
SELECT uf,
       municipio,
       COUNT(*) AS postos,
       ROUND((percentile_cont(0.1) WITHIN GROUP (ORDER BY preco_posto))::numeric, 2) AS p10,
       ROUND((percentile_cont(0.9) WITHIN GROUP (ORDER BY preco_posto))::numeric, 2) AS p90,
       ROUND((percentile_cont(0.9) WITHIN GROUP (ORDER BY preco_posto)
            - percentile_cont(0.1) WITHIN GROUP (ORDER BY preco_posto))::numeric, 2) AS faixa_p10_p90
FROM preco_posto
GROUP BY uf, municipio
HAVING COUNT(*) >= 10
ORDER BY faixa_p10_p90 DESC
LIMIT 20;


-- =====================================================================
-- 5.5c  CONFERENCIA - quem sao os postos mais caros de Guaruja (gasolina)?
--       serve para checar se o maior valor do bloco 5.5 e um posto
--       isolado (e se ele esta marcado como atipico)
-- =====================================================================
SELECT p.revenda,
       f.cnpj,
       ROUND(AVG(f.valor_venda), 2) AS preco_medio,
       COUNT(*)                     AS obs,
       BOOL_OR(f.preco_atipico)     AS tem_atipico
FROM fato_preco f
JOIN dim_posto p ON p.cnpj = f.cnpj
WHERE p.municipio = 'GUARUJA'
  AND f.produto = 'gasolina'
  AND f.data_coleta > (SELECT MAX(data_coleta) FROM fato_preco) - INTERVAL '12 months'
GROUP BY p.revenda, f.cnpj
ORDER BY preco_medio DESC
LIMIT 5;
