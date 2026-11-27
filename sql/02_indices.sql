CREATE INDEX idx_fato_data         ON fato_preco (data_coleta);
CREATE INDEX idx_fato_produto_data ON fato_preco (produto, data_coleta);
ANALYZE fato_preco;
