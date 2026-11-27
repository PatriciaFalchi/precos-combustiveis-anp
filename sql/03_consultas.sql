-- =====================================================================
-- PROJETO: Precos de combustiveis no Brasil (ANP), jan/2023 a jun/2026
-- ARQUIVO: 03_consultas.sql  (banco: combustiveis)
--
-- COMO USAR NO pgAdmin:
--   1. Abra o Query Tool no banco "combustiveis".
--   2. Abra este arquivo (icone de pasta, no topo do Query Tool) ou cole tudo.
--   3. Para rodar UM bloco: selecione com o mouse so o texto do bloco
--      (do comentario de titulo ate o ponto e virgula) e aperte F5.
--   4. Veja o resultado na aba "Data Output" (embaixo).
--   5. NAO apague nada: va para o proximo bloco.
-- =====================================================================


-- =====================================================================
-- 5.0  VIEW: preco medio por UF, produto e mes
--      (pode rodar de novo sem erro)
-- =====================================================================
CREATE OR REPLACE VIEW vw_preco_mensal_uf AS
SELECT p.uf,
       f.produto,
       date_trunc('month', f.data_coleta)::date AS mes,
       COUNT(*)                                  AS observacoes,
       ROUND(AVG(f.valor_venda), 3)              AS preco_medio
FROM fato_preco f
JOIN dim_posto p ON p.cnpj = f.cnpj
GROUP BY p.uf, f.produto, date_trunc('month', f.data_coleta)::date;


-- =====================================================================
-- 5.1a  PERGUNTA 1 - O etanol compensa? Ultimo mes, por UF
--       razao = preco etanol / preco gasolina (0,70 e so uma regra pratica)
-- =====================================================================
WITH par AS (
    SELECT uf, mes,
           MAX(preco_medio) FILTER (WHERE produto = 'etanol')   AS etanol,
           MAX(preco_medio) FILTER (WHERE produto = 'gasolina') AS gasolina
    FROM vw_preco_mensal_uf
    WHERE produto IN ('etanol', 'gasolina')
    GROUP BY uf, mes
)
SELECT uf,
       etanol,
       gasolina,
       ROUND(etanol / gasolina, 3) AS razao,
       CASE WHEN etanol / gasolina <= 0.70 THEN 'compensa'
            ELSE 'nao compensa' END AS veredito
FROM par
WHERE mes = (SELECT MAX(mes) FROM vw_preco_mensal_uf)
  AND etanol IS NOT NULL
  AND gasolina IS NOT NULL
ORDER BY razao;


-- =====================================================================
-- 5.1b  PERGUNTA 1 - Em quantos dos ultimos 12 meses o etanol compensou
-- =====================================================================
WITH par AS (
    SELECT uf, mes,
           MAX(preco_medio) FILTER (WHERE produto = 'etanol')   AS etanol,
           MAX(preco_medio) FILTER (WHERE produto = 'gasolina') AS gasolina
    FROM vw_preco_mensal_uf
    WHERE produto IN ('etanol', 'gasolina')
    GROUP BY uf, mes
),
razao AS (
    SELECT uf, mes, etanol / gasolina AS r
    FROM par
    WHERE etanol IS NOT NULL
      AND gasolina IS NOT NULL
)
SELECT uf,
       COUNT(*) FILTER (WHERE r <= 0.70) AS meses_compensa,
       COUNT(*)                          AS meses_total,
       ROUND(100.0 * COUNT(*) FILTER (WHERE r <= 0.70) / COUNT(*), 0) AS pct_meses
FROM razao
WHERE mes > (SELECT MAX(data_coleta) FROM fato_preco) - INTERVAL '12 months'
GROUP BY uf
ORDER BY pct_meses DESC, uf;


-- =====================================================================
-- 5.2  PERGUNTA 2 - UFs mais caras e mais baratas (ultimos 12 meses)
--      gasolina e diesel S10: 3 mais caras e 3 mais baratas de cada
-- =====================================================================
WITH base AS (
    SELECT p.uf, f.produto,
           AVG(f.valor_venda) AS preco_medio,
           COUNT(*)           AS obs
    FROM fato_preco f
    JOIN dim_posto p ON p.cnpj = f.cnpj
    WHERE f.produto IN ('gasolina', 'diesel_s10')
      AND f.data_coleta > (SELECT MAX(data_coleta) FROM fato_preco) - INTERVAL '12 months'
    GROUP BY p.uf, f.produto
),
ranking AS (
    SELECT produto, uf,
           ROUND(preco_medio, 2) AS preco_medio,
           obs,
           RANK() OVER (PARTITION BY produto ORDER BY preco_medio DESC) AS pos_caro,
           RANK() OVER (PARTITION BY produto ORDER BY preco_medio ASC)  AS pos_barato
    FROM base
)
SELECT produto, uf, preco_medio, obs, pos_caro, pos_barato
FROM ranking
WHERE pos_caro <= 3 OR pos_barato <= 3
ORDER BY produto, preco_medio DESC;


-- =====================================================================
-- 5.3  PERGUNTA 3 - Evolucao mensal do preco medio: Brasil e SP
--      (inclui variacao em % contra o mes anterior)
--      Dica: clique no titulo da coluna "produto" para ordenar/filtrar
-- =====================================================================
WITH base AS (
    SELECT f.produto,
           date_trunc('month', f.data_coleta)::date AS mes,
           p.uf,
           f.valor_venda
    FROM fato_preco f
    JOIN dim_posto p ON p.cnpj = f.cnpj
),
serie AS (
    SELECT 'Brasil' AS recorte, produto, mes, AVG(valor_venda) AS preco_medio
    FROM base
    GROUP BY produto, mes
    UNION ALL
    SELECT 'SP' AS recorte, produto, mes, AVG(valor_venda) AS preco_medio
    FROM base
    WHERE uf = 'SP'
    GROUP BY produto, mes
)
SELECT recorte,
       produto,
       mes,
       ROUND(preco_medio, 2) AS preco_medio,
       ROUND(100.0 * (preco_medio / LAG(preco_medio) OVER (
             PARTITION BY recorte, produto ORDER BY mes) - 1), 1) AS var_mensal_pct
FROM serie
ORDER BY recorte, produto, mes;


-- =====================================================================
-- 5.4a  PERGUNTA 4 - Bandeira branca x bandeirados (ultimos 12 meses)
--       visao geral por produto
-- =====================================================================
WITH base AS (
    SELECT f.produto,
           CASE WHEN f.bandeira = 'BRANCA' THEN 'branca'
                ELSE 'bandeirado' END AS tipo,
           f.valor_venda
    FROM fato_preco f
    WHERE f.produto IN ('gasolina', 'etanol', 'diesel_s10')
      AND f.data_coleta > (SELECT MAX(data_coleta) FROM fato_preco) - INTERVAL '12 months'
)
SELECT produto,
       tipo,
       ROUND(AVG(valor_venda), 2) AS preco_medio,
       COUNT(*)                   AS obs
FROM base
GROUP BY produto, tipo
ORDER BY produto, tipo;


-- =====================================================================
-- 5.4b  PERGUNTA 4 - Mesma comparacao DENTRO de cada UF (gasolina)
--       diferenca negativa = bandeira branca mais barata naquela UF
-- =====================================================================
WITH base AS (
    SELECT p.uf,
           CASE WHEN f.bandeira = 'BRANCA' THEN 'branca'
                ELSE 'bandeirado' END AS tipo,
           f.valor_venda
    FROM fato_preco f
    JOIN dim_posto p ON p.cnpj = f.cnpj
    WHERE f.produto = 'gasolina'
      AND f.data_coleta > (SELECT MAX(data_coleta) FROM fato_preco) - INTERVAL '12 months'
),
medias AS (
    SELECT uf, tipo, AVG(valor_venda) AS m
    FROM base
    GROUP BY uf, tipo
)
SELECT uf,
       ROUND(MAX(m) FILTER (WHERE tipo = 'branca'), 2)     AS branca,
       ROUND(MAX(m) FILTER (WHERE tipo = 'bandeirado'), 2) AS bandeirado,
       ROUND(MAX(m) FILTER (WHERE tipo = 'branca')
           - MAX(m) FILTER (WHERE tipo = 'bandeirado'), 2) AS diferenca
FROM medias
GROUP BY uf
ORDER BY diferenca;


-- =====================================================================
-- 5.5  PERGUNTA 5 - Variacao de preco dentro do municipio (gasolina)
--      ultimos 12 meses; so municipios com 5 postos ou mais
-- =====================================================================
WITH preco_posto AS (
    SELECT p.uf, p.municipio, f.cnpj,
           AVG(f.valor_venda) AS preco_posto
    FROM fato_preco f
    JOIN dim_posto p ON p.cnpj = f.cnpj
    WHERE f.produto = 'gasolina'
      AND f.data_coleta > (SELECT MAX(data_coleta) FROM fato_preco) - INTERVAL '12 months'
    GROUP BY p.uf, p.municipio, f.cnpj
)
SELECT uf,
       municipio,
       COUNT(*)                                       AS postos,
       ROUND(MIN(preco_posto), 2)                     AS menor,
       ROUND(MAX(preco_posto), 2)                     AS maior,
       ROUND(MAX(preco_posto) - MIN(preco_posto), 2)  AS spread,
       ROUND(100.0 * (MAX(preco_posto) - MIN(preco_posto)) / AVG(preco_posto), 1) AS spread_pct
FROM preco_posto
GROUP BY uf, municipio
HAVING COUNT(*) >= 5
ORDER BY spread DESC
LIMIT 20;


-- =====================================================================
-- 5.6  TESTE DE SENSIBILIDADE - os precos atipicos mudam a media?
--      se a diferenca for de centavos, a regra de limpeza nao pesa
-- =====================================================================
SELECT produto,
       ROUND(AVG(valor_venda), 3)                                  AS com_atipicos,
       ROUND(AVG(valor_venda) FILTER (WHERE NOT preco_atipico), 3) AS sem_atipicos,
       ROUND(AVG(valor_venda)
           - AVG(valor_venda) FILTER (WHERE NOT preco_atipico), 3) AS diferenca
FROM fato_preco
GROUP BY produto
ORDER BY produto;
