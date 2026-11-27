-- Projeto: preços de combustíveis (ANP), jan/2023 a jun/2026
-- Cria o modelo: 2 dimensões e 1 tabela fato

CREATE TABLE dim_produto (
    produto TEXT PRIMARY KEY,
    familia TEXT NOT NULL
);

CREATE TABLE dim_posto (
    cnpj      TEXT PRIMARY KEY,
    revenda   TEXT,
    municipio TEXT NOT NULL,
    uf        CHAR(2) NOT NULL,
    regiao    TEXT
);

CREATE TABLE fato_preco (
    id            BIGSERIAL PRIMARY KEY,
    cnpj          TEXT NOT NULL REFERENCES dim_posto (cnpj),
    produto       TEXT NOT NULL REFERENCES dim_produto (produto),
    data_coleta   DATE NOT NULL,
    valor_venda   NUMERIC(6,2) NOT NULL,
    bandeira      TEXT,
    preco_atipico BOOLEAN NOT NULL,
    UNIQUE (cnpj, produto, data_coleta)
);
