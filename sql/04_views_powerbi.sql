-- =====================================================================
-- PROJETO: Precos de combustiveis no Brasil (ANP), jan/2023 a jun/2026
-- ARQUIVO: 04_views_powerbi.sql  (banco: combustiveis)
--
-- Prepara as tabelas resumidas que alimentam o painel em Power BI.
--
-- COMO USAR NO pgAdmin:
--   1. Rode os blocos 6.1 e 6.2 (cada um cria uma view): selecione o bloco
--      e aperte F5. Deve aparecer "Query returned successfully".
--   2. Rode cada bloco de EXPORTACAO (6.3, 6.4, 6.5), um por vez.
--   3. No resultado (Data Output), clique no icone de seta para baixo
--      (Download as CSV) e salve em C:\temp\combustiveis\powerbi
--      com o nome indicado no titulo do bloco.
-- =====================================================================


-- =====================================================================
-- 6.1  VIEW: preco medio por UF, produto e mes (ja existe; pode rodar de novo)
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
-- 6.2  VIEW: preco medio por UF, produto, mes e tipo de bandeira
-- =====================================================================
CREATE OR REPLACE VIEW vw_preco_mensal_uf_bandeira AS
SELECT p.uf,
       f.produto,
       date_trunc('month', f.data_coleta)::date AS mes,
       CASE WHEN f.bandeira = 'BRANCA' THEN 'branca'
            ELSE 'bandeirado' END               AS tipo_bandeira,
       COUNT(*)                                  AS observacoes,
       ROUND(AVG(f.valor_venda), 3)              AS preco_medio
FROM fato_preco f
JOIN dim_posto p ON p.cnpj = f.cnpj
GROUP BY p.uf,
         f.produto,
         date_trunc('month', f.data_coleta)::date,
         CASE WHEN f.bandeira = 'BRANCA' THEN 'branca'
              ELSE 'bandeirado' END;


-- =====================================================================
-- 6.3  EXPORTAR como: preco_mensal_uf.csv
--      (esperado: cerca de 5.700 linhas)
-- =====================================================================
SELECT uf, produto, mes, observacoes, preco_medio
FROM vw_preco_mensal_uf
ORDER BY mes, uf, produto;


-- =====================================================================
-- 6.4  EXPORTAR como: preco_mensal_uf_bandeira.csv
--      (esperado: cerca de 11.000 linhas)
-- =====================================================================
SELECT uf, produto, mes, tipo_bandeira, observacoes, preco_medio
FROM vw_preco_mensal_uf_bandeira
ORDER BY mes, uf, produto, tipo_bandeira;


-- =====================================================================
-- 6.5  EXPORTAR como: uf_regiao.csv
--      (esperado: 27 linhas)
-- =====================================================================
SELECT uf, MIN(regiao) AS regiao
FROM dim_posto
GROUP BY uf
ORDER BY uf;
