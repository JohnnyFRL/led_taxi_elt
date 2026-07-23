# Perfilamento - Camada RAW

## Objetivo

Investigar a qualidade dos dados carregados na camada **RAW** (`raw_yellow_tripdata` e `raw_taxi_zone_lookup`), identificando nulos, duplicidades, valores fora de domínio e inconsistências, antes de qualquer decisão de tratamento na camada de staging.

---

# Arquivos de Entrada

| Tabela | Origem |
|---|---|
| raw_yellow_tripdata | yellow_tripdata_2024-01.parquet |
| raw_taxi_zone_lookup | taxi_zone_lookup.csv |

---

# Script SQL

As consultas foram executadas via DuckDB, através da conexão Python (`con.execute(...).fetchdf()`), sem uso de CTE ou window functions.

---

## 4.1 Valores nulos por coluna

Consulta:

```sql
SELECT COUNT(*) AS total_linhas,
       COUNT(*) - COUNT(VendorID) AS nulos_vendorid,
       COUNT(*) - COUNT(tpep_pickup_datetime) AS nulos_pickup_datetime,
       COUNT(*) - COUNT(tpep_dropoff_datetime) AS nulos_dropoff_datetime,
       COUNT(*) - COUNT(passenger_count) AS nulos_passenger_count,
       COUNT(*) - COUNT(trip_distance) AS nulos_trip_distance,
       COUNT(*) - COUNT(RatecodeID) AS nulos_ratecodeid,
       COUNT(*) - COUNT(store_and_fwd_flag) AS nulos_store_and_fwd_flag,
       COUNT(*) - COUNT(PULocationID) AS nulos_pulocationid,
       COUNT(*) - COUNT(DOLocationID) AS nulos_dolocationid,
       COUNT(*) - COUNT(payment_type) AS nulos_payment_type,
       COUNT(*) - COUNT(fare_amount) AS nulos_fare_amount,
       COUNT(*) - COUNT(extra) AS nulos_extra,
       COUNT(*) - COUNT(mta_tax) AS nulos_mta_tax,
       COUNT(*) - COUNT(tip_amount) AS nulos_tip_amount,
       COUNT(*) - COUNT(tolls_amount) AS nulos_tolls_amount,
       COUNT(*) - COUNT(improvement_surcharge) AS nulos_improvement_surcharge,
       COUNT(*) - COUNT(total_amount) AS nulos_total_amount,
       COUNT(*) - COUNT(congestion_surcharge) AS nulos_congestion_surcharge,
       COUNT(*) - COUNT(Airport_fee) AS nulos_airport_fee
FROM raw_yellow_tripdata;
```

Resultado:

Apenas 5 colunas apresentam nulos, todas com **140.162** linhas afetadas: `passenger_count`, `RatecodeID`, `store_and_fwd_flag`, `congestion_surcharge` e `Airport_fee`. As demais 14 colunas estão 100% preenchidas.

---

## 4.2 Linhas duplicadas

Consulta:

```sql
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime,
       PULocationID, DOLocationID, COUNT(*) AS qtd
FROM raw_yellow_tripdata
GROUP BY VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, PULocationID, DOLocationID
HAVING COUNT(*) > 1
ORDER BY qtd DESC;
```

Resultado:

**31.109 grupos** de registros com mesmo Vendor, pickup, dropoff, origem e destino, indicando possíveis duplicidades a serem investigadas na camada de staging.

---

## 4.3 Domínio de payment_type

Consulta:

```sql
SELECT payment_type, COUNT(*) AS qtd
FROM raw_yellow_tripdata
GROUP BY payment_type
ORDER BY qtd DESC;
```

Resultado:

O código `0` (Flex Fare trip) aparece em **140.162** linhas — o mesmo número identificado como nulo em 4.1. Isso indica que essas linhas pertencem a um segmento de corridas com esquema reduzido de informações, e não a um erro de carga.

---

## 4.4 Domínio de RatecodeID

Consulta:

```sql
SELECT RatecodeID, COUNT(*) AS qtd
FROM raw_yellow_tripdata
GROUP BY RatecodeID
ORDER BY qtd DESC;
```

Resultado:

O código `99` (Null/unknown, conforme dicionário de dados) aparece em **28.663** linhas — distinto do `NULL` real de banco (140.162 linhas do grupo Flex Fare). São duas representações diferentes de "desconhecido" que precisam ser tratadas na etapa de staging.

---

## 4.5 Domínio de VendorID

Consulta:

```sql
SELECT VendorID, COUNT(*) AS qtd
FROM raw_yellow_tripdata
GROUP BY VendorID
ORDER BY qtd DESC;
```

Resultado:

Apenas os códigos `1` (Creative Mobile Technologies), `2` (Curb Mobility) e `6` (Myle Technologies) aparecem nos dados. O código `6` representa um volume muito baixo (260 corridas). O código `7` (Helix), presente no dicionário de dados vigente, não aparece — provavelmente por ser um vendor que passou a operar após janeiro/2024.

---

## 4.6 Domínio de passenger_count

Consulta:

```sql
SELECT passenger_count, COUNT(*) AS qtd
FROM raw_yellow_tripdata
GROUP BY passenger_count
ORDER BY passenger_count;
```

Resultado:

**31.465 corridas com 0 passageiros**, valor fisicamente inconsistente que precisa de regra de tratamento. Valores extremos como 7, 8 e 9 passageiros aparecem em volume muito baixo.

---

## 4.7 Domínio de store_and_fwd_flag

Consulta:

```sql
SELECT store_and_fwd_flag, COUNT(*) AS qtd
FROM raw_yellow_tripdata
GROUP BY store_and_fwd_flag
ORDER BY qtd DESC;
```

Resultado:

Confirma o mesmo padrão: 140.162 linhas nulas (grupo Flex Fare). Das linhas restantes, a grande maioria (`N`) não passou por "store and forward", indicando conexão em tempo real do taxímetro com o servidor.

---

# Resultado

- Identificado um grupo consistente de **140.162 linhas** (~4,7% do total) sem informação em 5 colunas, associado ao `payment_type = 0` (Flex Fare) — não parece erro de carga, e sim um segmento de dados com esquema reduzido.
- **31.109 grupos** de possíveis registros duplicados identificados.
- **31.465 corridas** com `passenger_count = 0`, valor inconsistente.
- Identificados dois códigos distintos de "desconhecido" em `RatecodeID` (`NULL` e `99`).
- `VendorID` restrito a 3 códigos no período (1, 2 e 6); código 7 (Helix) ainda não operava.

---