# 📊 Insights Analíticos

## Objetivo

Este documento apresenta os principais insights obtidos a partir das consultas analíticas realizadas sobre o conjunto de dados das corridas de táxi amarelo da cidade de Nova York. As análises foram executadas utilizando o modelo dimensional desenvolvido no projeto.

---

# 1. Zonas com maior quantidade de embarques

A análise dos locais de embarque mostrou que a maior concentração de corridas ocorre em regiões centrais de Manhattan e nos principais aeroportos da cidade.

### Destaques

| Zona | Distrito | Embarques |
|------|-----------|----------:|
| JFK Airport | Queens | 141.594 |
| Upper East Side South | Manhattan | 138.338 |
| Midtown Center | Manhattan | 137.976 |
| Upper East Side North | Manhattan | 130.532 |
| Midtown East | Manhattan | 103.380 |

### Insight

A demanda por táxis está concentrada principalmente em Manhattan, além dos aeroportos JFK e LaGuardia, evidenciando regiões de maior fluxo de passageiros.

---

# 2. Zonas com maior quantidade de desembarques

Os principais destinos das viagens também estão concentrados em Manhattan.

### Destaques

| Zona | Distrito | Desembarques |
|------|-----------|-------------:|
| Upper East Side North | Manhattan | 136.214 |
| Upper East Side South | Manhattan | 125.384 |
| Midtown Center | Manhattan | 107.146 |
| Times Square/Theatre District | Manhattan | 86.266 |
| Lincoln Square East | Manhattan | 85.520 |

### Insight

Manhattan concentra tanto a origem quanto o destino da maioria das viagens realizadas.

---

# 3. Corridas com apenas um passageiro

Foi observado que aproximadamente **77,5%** das corridas transportam apenas um passageiro.

### Resultado

- Total de corridas: **2.785.071**
- Corridas com 1 passageiro: **2.158.450**
- Percentual: **77,5%**

### Insight

O serviço é predominantemente utilizado por passageiros individuais.

---

# 4. Destinos com maior valor médio das corridas

As viagens com maior valor médio possuem como destino regiões mais afastadas da cidade.

### Destaques

- Newark Airport
- Outside of NYC
- Staten Island

### Insight

Quanto maior a distância percorrida, maior tende a ser o valor final da corrida.

---

# 5. Destinos com maior duração média

As maiores durações foram observadas em bairros periféricos e regiões mais distantes do centro urbano.

### Destaques

- Hammels/Arverne
- Saint George/New Brighton
- Borough Park
- Co-Op City

### Insight

A duração média das viagens está diretamente relacionada à distância e às condições do trânsito.

---

# 6. Zonas com maior valor médio das corridas

As regiões dos aeroportos apresentam os maiores valores médios por viagem.

### Destaques

| Zona | Valor médio (US$) |
|------|------------------:|
| Outside of NYC | 84,79 |
| JFK Airport | 77,25 |
| Baisley Park | 72,63 |
| Springfield Gardens South | 71,85 |
| LaGuardia Airport | 65,25 |

### Insight

Corridas com origem nos aeroportos apresentam maior ticket médio devido às maiores distâncias percorridas.

---

# 7. Formas de pagamento

A maior parte das corridas foi paga com cartão de crédito.

### Resultado

| Forma de pagamento | Corridas |
|--------------------|----------:|
| Credit Card | 2.297.128 |
| Cash | 430.090 |
| Dispute | 42.829 |
| No Charge | 15.024 |

### Insight

Os pagamentos eletrônicos predominam nas corridas analisadas.

---

# 8. Regiões com maior média de gorjetas

Os maiores valores médios de gorjeta também foram registrados em regiões próximas aos aeroportos.

### Destaques

| Zona | Gorjeta média (US$) |
|------|--------------------:|
| JFK Airport | 8,96 |
| LaGuardia Airport | 8,71 |
| Outside of NYC | 8,52 |
| East Elmhurst | 8,36 |

### Insight

Corridas de maior valor tendem a receber gorjetas mais elevadas.

---

# 9. Distritos com maior quantidade de corridas

A análise por distrito evidencia uma forte concentração das viagens em Manhattan.

### Resultado

| Distrito | Corridas |
|-----------|---------:|
| Manhattan | 2.494.680 |
| Queens | 258.391 |
| Brooklyn | 16.950 |
| Bronx | 4.964 |
| Staten Island | 30 |

### Insight

A maior parte da demanda pelo serviço de táxi ocorre em Manhattan, consolidando o distrito como principal centro de mobilidade urbana da cidade.

---

# Conclusão

As consultas analíticas demonstraram que o modelo dimensional implementado permitiu responder diferentes perguntas de negócio de forma eficiente.

Os resultados evidenciam que:

- Manhattan concentra a maior parte dos embarques, desembarques e corridas.
- Os aeroportos JFK e LaGuardia apresentam elevado volume de viagens, maior ticket médio e maiores gorjetas.
- Aproximadamente 77,5% das viagens transportam apenas um passageiro.
- O cartão de crédito é a principal forma de pagamento utilizada.
- Corridas para regiões mais afastadas apresentam maior duração e maior valor médio.