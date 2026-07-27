# Modelagem Dimensional

## Objetivo

A modelagem dimensional foi desenvolvida utilizando o esquema estrela (Star Schema), com o objetivo de organizar os dados para facilitar consultas analíticas, reduzir redundância, melhorar o desempenho das consultas e simplificar a construção de relatórios e dashboards.

---

## Esquema Estrela

O modelo é composto por uma tabela fato e quatro tabelas dimensão.

```text
                 dim_data
                     │
                     │
dim_pagamento ─ fato_corridas ─ dim_localizacao
                     │
                     │
                dim_tarifa
```

---

## Granularidade

A granularidade da tabela **fato_corridas** é de **uma corrida de táxi por registro**. Cada linha representa uma única viagem realizada, contendo suas medidas (distância, valores da corrida, gorjeta, pedágios, entre outros) e as referências para as tabelas dimensão.

---

## Chaves do Modelo

### Chaves Primárias (PK)

| Tabela | Chave Primária |
|---------|----------------|
| dim_data | data |
| dim_localizacao | LocationID |
| dim_pagamento | payment_type |
| dim_tarifa | RatecodeID |

### Chaves Estrangeiras (FK)

A tabela **fato_corridas** possui as seguintes chaves estrangeiras:

| Chave Estrangeira | Referência |
|-------------------|------------|
| data | dim_data(data) |
| payment_type | dim_pagamento(payment_type) |
| RatecodeID | dim_tarifa(RatecodeID) |
| PULocationID | dim_localizacao(LocationID) |
| DOLocationID | dim_localizacao(LocationID) |

---

## Tabela Fato

### fato_corridas

A tabela **fato_corridas** representa cada corrida de táxi realizada e concentra os dados quantitativos utilizados nas análises.

Campos de medida:

- trip_distance
- fare_amount
- extra
- mta_tax
- tip_amount
- tolls_amount
- improvement_surcharge
- congestion_surcharge
- Airport_fee
- total_amount

Campos de relacionamento:

- data
- payment_type
- RatecodeID
- PULocationID
- DOLocationID

### Justificativa dos atributos

Os atributos presentes na tabela fato representam as **medidas quantitativas** da corrida, como distância percorrida, valor da tarifa, gorjeta, pedágios e valor total da viagem. Essas informações são utilizadas em operações analíticas como soma, média, máximo, mínimo e contagem.

Além das medidas, a tabela contém as chaves estrangeiras responsáveis por relacionar cada corrida às dimensões de tempo, localização, pagamento e tarifa.

---

## Tabelas Dimensão

### dim_data

Armazena informações temporais extraídas da data de embarque da corrida.

Campos:

- data
- ano
- mes
- dia
- hora
- dia_semana

Esses atributos permitem realizar análises por período, como quantidade de corridas por dia, mês, hora ou dia da semana.

---

### dim_localizacao

Obtida a partir da tabela de zonas disponibilizada pela TLC.

Campos:

- LocationID
- Borough
- Zone
- service_zone

Essa dimensão armazena informações descritivas das regiões de embarque e desembarque, evitando repetição desses dados na tabela fato.

---

### dim_pagamento

Armazena os tipos de pagamento utilizados nas corridas.

Campos:

- payment_type
- descricao

Exemplos:

- Credit Card
- Cash
- No Charge
- Dispute
- Unknown
- Voided Trip

Essa dimensão permite analisar a distribuição e o faturamento por forma de pagamento.

---

### dim_tarifa

Armazena os tipos de tarifa aplicados às corridas.

Campos:

- RatecodeID
- descricao

Exemplos:

- Standard Rate
- JFK
- Newark
- Nassau/Westchester
- Negotiated Fare
- Group Ride
- Unknown

Essa dimensão possibilita análises por categoria de tarifa aplicada às viagens.

---

## Justificativa da Modelagem

Foi adotado o modelo dimensional utilizando o **Esquema Estrela (Star Schema)** por ser um dos modelos mais utilizados em ambientes analíticos (OLAP).

Nesse modelo, a tabela **fato_corridas** concentra os eventos do negócio (as corridas de táxi) e suas medidas quantitativas, enquanto as tabelas dimensão armazenam informações descritivas utilizadas para classificação, agrupamento e filtragem das análises.

A utilização do esquema estrela proporciona as seguintes vantagens:

- separação entre medidas e atributos descritivos;
- redução da redundância de dados;
- consultas SQL mais simples e intuitivas;
- melhor desempenho em consultas analíticas;
- facilidade na construção de dashboards e relatórios;
- maior organização e manutenção do banco de dados.

Essa estrutura permite responder de forma eficiente perguntas de negócio, como receita por região, quantidade de corridas por período, formas de pagamento mais utilizadas e análises por tipo de tarifa.