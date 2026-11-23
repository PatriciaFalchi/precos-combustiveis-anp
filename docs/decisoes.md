# Decisões de tratamento dos dados

Fonte: ANP, Série Histórica de Preços de Combustíveis (combustíveis automotivos, arquivos semestrais).
Período: 02/01/2023 a 30/06/2026 (7 arquivos: ca-2023-01 a ca-2026-01).

## Funil de linhas

| Etapa | Linhas |
|---|---|
| Linhas lidas (7 arquivos) | 3.038.685 |
| Sem linhas vazias | 3.029.571 |
| Com preço de venda válido | 3.029.571 |
| Somente R$/litro (sem GNV) | 2.965.460 |
| Sem duplicados posto+produto+dia | 2.965.442 |
| Sem preços acima de 1,5x a mediana | 2.964.388 |

A contagem de linhas lidas bate com a de cada arquivo (nenhuma linha perdida na leitura).

## Decisões

| Decisão | Linhas | Motivo |
|---|---|---|
| Remover linhas totalmente vazias | 9.114 | Só separadores, sem nenhum dado |
| Descartar a coluna `valor_compra` | — | 100% vazia |
| Descartar colunas de endereço (rua, número, complemento, bairro, CEP) | — | Não usadas nas perguntas; o posto é identificado por CNPJ, revenda, município e UF |
| Excluir GNV | 64.111 | Unidade em R$/m³, não comparável com os produtos em R$/litro. O m³ aparece com duas grafias diferentes no arquivo |
| Remover duplicados por posto+produto+dia (mantida a primeira ocorrência) | 18 | 14 idênticos e 4 com preços conflitantes (mesmo posto, mesmo dia, dois preços) |
| Remover preço acima de 1,5x a mediana do produto no mesmo estado e mês | 1.054 | Prováveis erros: por exemplo, etanol com preço de gasolina em dois postos no mesmo dia e diesel S10 a R$ 9,00 repetido |
| Marcar como atípico (coluna `preco_atipico`) o preço abaixo de 0,7x ou entre 1,3x e 1,5x da mediana | 8.249 | Mantidos na base: podem ser preços regionais reais (ex.: etanol em região produtora) |

## Verificações que passaram sem ajuste
- Datas: 0 inválidas.
- Preços: 0 falhas de conversão.
- CNPJ: 100% com 14 dígitos.
- UF e município: nenhum nulo; 27 UFs distintas.
- Colunas idênticas nos 7 arquivos; codificação UTF-8 com marcador (utf-8-sig) e separador ponto e vírgula.

## Produtos mantidos
gasolina, gasolina aditivada, etanol, diesel S10 e diesel (todos em R$/litro).

## Limites do método
- A regra de 1,5x a mediana é um julgamento, não uma prova de erro. Foi escolhida após olhar a distribuição da razão preço/mediana: o lado baixo parecia preço regional real, e o lado alto trazia sinais de erro.
- Os preços vêm de uma pesquisa semanal por amostragem de postos (cerca de 459 localidades), não do universo de postos do país.
- Uma regra anterior (30% em torno da mediana) foi descartada por marcar como suspeitos preços que pareciam reais.
