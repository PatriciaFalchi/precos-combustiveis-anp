# Perguntas de negócio

Projeto: preços de combustíveis no Brasil (ANP), jan/2023 a jun/2026.
Fonte: Série Histórica de Preços de Combustíveis (ANP, dados abertos).

| # | Pergunta | Como medir |
|---|----------|------------|
| 1 | O etanol compensa? | Razão preço do etanol ÷ preço da gasolina, por estado e mês. A regra dos 70% é só uma heurística popular. |
| 2 | Quais estados têm a gasolina e o diesel mais caros e mais baratos? | Preço médio por estado e produto, em ranking. |
| 3 | Como o preço médio evoluiu mês a mês, no Brasil e em SP? | Preço médio mensal por produto. |
| 4 | Postos de bandeira branca cobram diferente dos bandeirados? | Preço médio por tipo de bandeira, por produto e estado. |
| 5 | Quanto o preço varia dentro de um mesmo município? | Diferença entre o maior e o menor preço (spread) dentro de cada município. |

## Limitação conhecida
Os preços vêm de uma pesquisa semanal por amostragem de postos, não do universo de postos do país.
