# Modelagem Dimensional

## Objetivo

A modelagem dimensional foi desenvolvida utilizando o esquema estrela (Star Schema), com o objetivo de organizar os dados para facilitar consultas analíticas, reduzir redundância e melhorar o desempenho das análises.

---

## Esquema Estrela

O modelo é composto por uma tabela fato e quatro tabelas dimensão.

```
                 dim_data
                     │
                     │
dim_pagamento ─ fato_corridas ─ dim_localizacao
                     │
                     │
                dim_tarifa
```

---

## Tabela Fato

### fato_corridas

Representa cada corrida de táxi realizada.

Contém as métricas que serão utilizadas nas análises, como:

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

Além disso, possui as referências para as dimensões:

- payment_type
- RatecodeID
- PULocationID
- DOLocationID
- data

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

Permite realizar análises por período.

---

### dim_localizacao

Obtida a partir do arquivo de zonas da TLC.

Campos:

- LocationID
- Borough
- Zone
- service_zone

É utilizada para identificar tanto o local de embarque quanto o de desembarque.

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
- Negotiated Fare
- Group Ride

---

## Justificativa da Modelagem

A utilização do esquema estrela permite:

- separar medidas das informações descritivas;
- reduzir redundância de dados;
- facilitar consultas SQL;
- simplificar a construção de relatórios e dashboards;
- melhorar o desempenho das consultas analíticas.

Nesse modelo, a tabela **fato_corridas** concentra os dados quantitativos das viagens, enquanto as tabelas dimensão armazenam informações descritivas utilizadas para classificação, agrupamento e filtragem das análises.