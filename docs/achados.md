# Principais achados

Base: ANP, Série Histórica de Preços de Combustíveis, de 02/01/2023 a 30/06/2026 (2.964.388 observações, 21.799 postos, 27 UFs).
"Últimos 12 meses" = jul/2025 a jun/2026. Preços em R$/litro, médias das observações da pesquisa semanal.
Os números das seções 1 a 5 vêm das consultas em `sql/`; a seção 6 traz o que o painel em Power BI (`powerbi/`) mostra e confirma essas leituras.

## 1. O etanol compensa?

Critério: razão preço do etanol ÷ preço da gasolina menor ou igual a 0,70 (regra prática popular, não uma lei).

- Em jun/2026, o etanol compensou em 7 estados: MT (0,571), SP (0,596), MS (0,630), GO (0,633), DF (0,636), PR (0,643) e MG (0,663). Nos outros 20 não compensou; a BA ficou logo acima do limite (0,703).
- Nos últimos 12 meses, o MS compensou em 12 de 12 meses; MT e SP em 10; PR em 8; GO em 5; MG em 4; DF em 2. Os outros 20 estados ficaram em zero.
- A razão mais alta é a do AP (0,906).
- Leitura: o etanol só compensa de forma consistente no Centro-Oeste, em SP e no PR.
- No painel, a razão do Brasil em jun/2026 é 0,67, e as 10 UFs com menor razão aparecem na mesma ordem das consultas (MT, SP, MS, GO, DF, PR, MG, BA), seguidas de AM e RR (0,71).

## 2. Estados mais caros e mais baratos (últimos 12 meses)

- Gasolina: AC (R$ 7,54), AM (R$ 7,23) e RR (R$ 7,16) são os mais caros; PI (R$ 6,13), PB (R$ 6,16) e AP (R$ 6,19), os mais baratos. A diferença entre o mais caro e o mais barato é de R$ 1,41 (cerca de 23%).
- Diesel S10: AC (R$ 7,85), AM (R$ 7,08) e RR (R$ 7,06) lideram; SE (R$ 6,27), PE (R$ 6,30) e ES (R$ 6,32) são os mais baratos. Diferença de R$ 1,58 (cerca de 25%).
- Os mesmos três estados (AC, AM e RR) são os mais caros nos dois combustíveis.
- Ressalva: a amostra do AC é bem menor (625 observações de gasolina) que a de estados maiores.
- Só em jun/2026 (painel, gasolina comum), o ranking muda: RR (R$ 7,68), AC (R$ 7,46) e RO (R$ 7,36) são os mais caros; MG (R$ 6,36), RS (R$ 6,44) e DF (R$ 6,46), os mais baratos. A diferença entre o mais caro e o mais barato é de R$ 1,32 (cerca de 21%). O ranking depende do período escolhido.

## 3. Evolução do preço (Brasil)

Gasolina comum e etanol (média nacional mensal, painel):

| Mês | Gasolina comum | Etanol | Razão etanol/gasolina |
|---|---|---|---|
| jun/2023 | R$ 5,39 | R$ 4,01 | 0,74 |
| jun/2024 | R$ 5,86 | R$ 4,05 | 0,69 |
| jun/2025 | R$ 6,22 | R$ 4,42 | 0,71 |
| jun/2026 | R$ 6,66 | R$ 4,44 | 0,67 |

- Gasolina: alta de cerca de 24% entre jun/2023 e jun/2026 e de 7,0% nos últimos 12 meses. O pico da série mensal é de R$ 6,76, em abr/2026.
- Etanol: alta de cerca de 11% entre jun/2023 e jun/2026 (percentuais calculados sobre valores arredondados). O pico é de R$ 4,87, em abr/2026, seguido de queda até R$ 4,44 em jun/2026.
- Razão etanol/gasolina: começou 2023 acima de 0,80 (cerca de 0,81, lido do gráfico), ficou em 0,70 ou menos em todos os meses de ago/2023 a dez/2024 (valores arredondados), acima de 0,70 durante todo 2025 e até abr/2026, e voltou a 0,69 em mai/2026 e 0,67 em jun/2026. O pico recente foi de 0,76, em fev/2026. A queda de 2026 vem sobretudo do etanol (de R$ 4,87 para R$ 4,44 entre abr e jun), enquanto a gasolina recuou pouco (de R$ 6,76 para R$ 6,66).
- Diesel (produto "diesel", jan/2023 a mar/2025): caiu de R$ 6,34 (jan/2023) para R$ 4,98 (jul/2023), cerca de 21%, e voltou a R$ 6,10 em set/2023, com altas de 10,9% e 10,4% em dois meses seguidos. Em 2024 ficou estável (entre R$ 5,92 e R$ 6,08) e subiu 4,9% em fev/2025.
- Diesel e diesel S10 andam praticamente juntos no painel. Entre fev e abr/2026 a série sobe de cerca de R$ 6,1 para cerca de R$ 7,5 (valores lidos do gráfico) e recua para R$ 7,12 no diesel S10 em jun/2026.
- Não atribuímos causas a essas variações sem uma fonte externa.

## 4. Bandeira branca × bandeirados (últimos 12 meses)

- No total, a bandeira branca é mais barata nos três produtos: gasolina R$ 6,30 contra R$ 6,43; etanol R$ 4,47 contra R$ 4,64; diesel S10 R$ 6,46 contra R$ 6,56. Cerca de um terço das observações é de bandeira branca.
- Dentro de cada estado (gasolina), o padrão se confirma, mas não é universal: a branca é 5 centavos ou mais mais barata em 15 estados (até R$ 0,34 no MS), 5 centavos ou mais mais cara em 6 estados e praticamente igual em 6.
- Caso isolado: no AM, a bandeira branca custa R$ 0,69 a mais (R$ 7,85 contra R$ 7,15).
- A comparação é descritiva: não controla por município nem por tipo de localização do posto.

Visão por região no painel (gasolina comum, período completo, 788.126 coletas):

| Região | Coletas | Branca | Bandeirado | Diferença (branca − bandeirado) |
|---|---|---|---|---|
| Norte | 56.490 | R$ 6,23 | R$ 6,47 | −R$ 0,24 |
| Nordeste | 156.038 | R$ 6,09 | R$ 6,10 | −R$ 0,01 |
| Sudeste | 375.566 | R$ 5,70 | R$ 5,94 | −R$ 0,24 |
| Sul | 137.531 | R$ 5,93 | R$ 6,07 | −R$ 0,14 |
| Centro-Oeste | 62.501 | R$ 5,92 | R$ 6,03 | −R$ 0,12 |
| Total | 788.126 | R$ 5,87 | R$ 6,04 | cerca de −R$ 0,17 |

A bandeira branca é mais barata em todas as regiões, com diferença quase nula no Nordeste. As diferenças foram calculadas sobre valores sem arredondar. Dentro de uma região, os postos de bandeira branca podem estar em municípios diferentes dos postos bandeirados, então a diferença não prova que a bandeira, por si só, cause o preço menor.

## 5. Variação de preço dentro do mesmo município (gasolina, últimos 12 meses)

- Medida usada: faixa entre o percentil 10 e o percentil 90 dos preços médios dos postos do município, sem preços atípicos e só em municípios com 10 postos ou mais. Ela não depende de um único posto extremo.
- Nos 20 municípios com maior dispersão, a faixa vai de R$ 0,98 a R$ 1,74 (cerca de 16% a 26% do preço). O topo é Barueri (SP), com R$ 5,89 a R$ 7,62, seguido por Valença (BA), Serra Talhada (PE) e Assis (SP).
- A dispersão não é só paulista: dos 20 municípios, 11 são de SP, 4 da BA, 2 do MA, e há também PE, RJ e PA.
- Aprendizado de método: uma primeira versão, com mínimo e máximo, colocava Guarujá (SP) no topo, com spread de R$ 3,67. O motivo era um único posto com média de R$ 9,56 (16 observações, marcado como atípico). A versão com percentis corrige esse efeito.

## 6. O painel em Power BI

O painel (`powerbi/painel_combustiveis.pbix`, com PDF e imagens na mesma pasta) tem 3 páginas:

1. **Visão geral:** preços do último mês (gasolina R$ 6,66, etanol R$ 4,44, diesel S10 R$ 7,12), variação da gasolina em 12 meses (+7,0%) e a série mensal por produto, com filtros por ano e região.
2. **Etanol × gasolina:** razão do Brasil ao longo do tempo (0,67 em jun/2026) com a linha de 0,70 e as 10 UFs com menor razão.
3. **Estados e bandeira:** as 10 UFs mais caras e as 10 mais baratas no último mês, e a diferença entre bandeira branca e bandeirados por região, para o produto escolhido.

Como o painel calcula:

- O preço médio é ponderado pelo número de observações de cada mês e UF, o que equivale à média simples das observações. Usar a média das médias mensais distorceria o resultado.
- "Último mês" é o mês mais recente do período filtrado: com Ano 2025 selecionado, por exemplo, vira dez/2025.
- O painel usa duas tabelas resumidas, geradas em SQL (`sql/04_views_powerbi.sql`): preço por UF, produto e mês, e o mesmo com o tipo de bandeira.
- A razão etanol/gasolina usa gasolina comum, sem a aditivada.

## Teste de sensibilidade

Incluir ou excluir os 8.249 preços marcados como atípicos muda o preço médio em menos de R$ 0,01 em todos os produtos (de R$ 0,001 no diesel a R$ 0,007 na gasolina aditivada).

## Limites

- Os preços vêm de uma pesquisa semanal por amostragem de postos (cerca de 459 localidades), não do universo de postos do país.
- As médias não ponderam por volume vendido; a composição de postos da pesquisa pode variar entre meses.
- Estados com poucos postos pesquisados (como AP e AC) oscilam mais e merecem leitura cuidadosa.
- A análise por município usa o cadastro mais recente de cada posto (5 CNPJs mudaram de município no período).
- A regra de 0,70 para o etanol é uma heurística, e não considera diferenças reais de consumo entre veículos.
- Os valores de diesel entre abr e jun/2026 e a razão de jan/2023 citados na seção 3 foram lidos do gráfico do painel, e não de uma consulta; devem ser tratados como aproximados.
- Os resultados são descritivos e não indicam relações de causa e efeito.
