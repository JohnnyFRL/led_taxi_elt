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

**Consulta complementar** — verificação de que os nulos das 5 colunas coincidem exatamente nas mesmas linhas:

```sql
SELECT
    COUNT(*) AS linhas_com_todas_nulas
FROM raw_yellow_tripdata
WHERE passenger_count IS NULL
  AND RatecodeID IS NULL
  AND store_and_fwd_flag IS NULL
  AND congestion_surcharge IS NULL
  AND Airport_fee IS NULL;
```

Resultado: **140.162 linhas**, confirmando que os nulos das 5 colunas ocorrem exatamente no mesmo conjunto de registros — reforçando a hipótese de que se trata de um segmento de dados com esquema reduzido (Flex Fare), e não de nulos aleatórios espalhados pela base.

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

## 4.8 Valores mínimos e máximos

Consulta:

```sql
SELECT
    MIN(trip_distance) AS min_distancia, MAX(trip_distance) AS max_distancia,
    MIN(fare_amount) AS min_tarifa, MAX(fare_amount) AS max_tarifa,
    MIN(extra) AS min_extra, MAX(extra) AS max_extra,
    MIN(mta_tax) AS min_mta_tax, MAX(mta_tax) AS max_mta_tax,
    MIN(tip_amount) AS min_tip, MAX(tip_amount) AS max_tip,
    MIN(tolls_amount) AS min_tolls, MAX(tolls_amount) AS max_tolls,
    MIN(improvement_surcharge) AS min_improvement, MAX(improvement_surcharge) AS max_improvement,
    MIN(total_amount) AS min_total, MAX(total_amount) AS max_total,
    MIN(congestion_surcharge) AS min_congestion, MAX(congestion_surcharge) AS max_congestion,
    MIN(Airport_fee) AS min_airport_fee, MAX(Airport_fee) AS max_airport_fee
FROM raw_yellow_tripdata;
```

Resultado:

Diversas colunas monetárias apresentam **valores negativos**, fisicamente inconsistentes para o escopo do projeto: `fare_amount` (mín. -899,00), `extra` (mín. -7,50), `mta_tax` (mín. -0,50), `tip_amount` (mín. -80,00), `tolls_amount` (mín. -80,00), `improvement_surcharge` (mín. -1,00), `total_amount` (mín. -900,00), `congestion_surcharge` (mín. -2,50) e `Airport_fee` (mín. -1,75). `trip_distance` também chama atenção pelo máximo de **312.722,30 milhas**, um outlier extremo. Esses casos precisam de regra de tratamento na staging.

---

## 4.9 Média e mediana

Consulta:

```sql
SELECT
    ROUND(AVG(trip_distance), 2) AS media_distancia, MEDIAN(trip_distance) AS mediana_distancia,
    ROUND(AVG(fare_amount), 2) AS media_tarifa, MEDIAN(fare_amount) AS mediana_tarifa,
    ROUND(AVG(extra), 2) AS media_extra, MEDIAN(extra) AS mediana_extra,
    ROUND(AVG(mta_tax), 2) AS media_mta_tax, MEDIAN(mta_tax) AS mediana_mta_tax,
    ROUND(AVG(tip_amount), 2) AS media_tip, MEDIAN(tip_amount) AS mediana_tip,
    ROUND(AVG(tolls_amount), 2) AS media_tolls, MEDIAN(tolls_amount) AS mediana_tolls,
    ROUND(AVG(improvement_surcharge), 2) AS media_improvement, MEDIAN(improvement_surcharge) AS mediana_improvement,
    ROUND(AVG(total_amount), 2) AS media_total, MEDIAN(total_amount) AS mediana_total,
    ROUND(AVG(congestion_surcharge), 2) AS media_congestion, MEDIAN(congestion_surcharge) AS mediana_congestion,
    ROUND(AVG(Airport_fee), 2) AS media_airport_fee, MEDIAN(Airport_fee) AS mediana_airport_fee,
    ROUND(AVG(passenger_count), 2) AS media_passageiros
FROM raw_yellow_tripdata;
```

Resultado:

A distância média das corridas é de **3,65 milhas** (mediana de 1,68), e a tarifa média é de **US$ 18,18** (mediana de US$ 12,80). A diferença expressiva entre média e mediana em `trip_distance` e `fare_amount` confirma a presença de outliers puxando a média para cima. O número médio de passageiros por corrida é de **1,34**.

---

## 4.10 Desembarque antes do embarque

Consulta:

```sql
SELECT COUNT(*) AS qtd
FROM raw_yellow_tripdata
WHERE tpep_dropoff_datetime < tpep_pickup_datetime;
```

Resultado:

**56 corridas** têm horário de desembarque anterior ao de embarque — uma inconsistência temporal clara. Ao detalhar essas linhas e agrupar por `VendorID`:

```sql
SELECT VendorID, COUNT(*) AS qtd
FROM raw_yellow_tripdata
WHERE tpep_dropoff_datetime < tpep_pickup_datetime
GROUP BY VendorID
ORDER BY qtd DESC;
```

**48 dessas 56 ocorrências** vêm do `VendorID = 6` (Myle Technologies) e as outras 8 do `VendorID = 1`, indicando que o problema está concentrado nesses fornecedores e reforçando a necessidade de remoção desses registros na staging.

---

## 4.11 Outliers (IQR)

Consulta (contagem de outliers por coluna numérica, usando a regra do intervalo interquartil — IQR — com limites de 1,5×IQR abaixo do Q1 e acima do Q3):

```sql
SELECT
    COUNT(*) FILTER (
        WHERE trip_distance < l.q1 - 1.5 * (l.q3 - l.q1)
           OR trip_distance > l.q3 + 1.5 * (l.q3 - l.q1)
    ) AS outliers_trip_distance
    -- (repetido para fare_amount, extra, mta_tax, tip_amount, tolls_amount,
    --  improvement_surcharge, total_amount, congestion_surcharge,
    --  Airport_fee e passenger_count, cada um com seu próprio Q1/Q3
    --  calculado via quantile_cont)
FROM raw_yellow_tripdata,
     (SELECT quantile_cont(trip_distance, 0.25) AS q1,
             quantile_cont(trip_distance, 0.75) AS q3
      FROM raw_yellow_tripdata) l;
```

Resultado:

O volume de outliers é alto em praticamente todas as colunas monetárias e de distância, o que é esperado dado o comportamento de cauda longa desse tipo de dado:

| Coluna | Outliers |
|---|---|
| trip_distance | 382.745 |
| fare_amount | 318.801 |
| extra | 47.566 |
| mta_tax | 64.150 |
| tip_amount | 216.756 |
| tolls_amount | 210.815 |
| improvement_surcharge | 36.914 |
| total_amount | 363.621 |
| congestion_surcharge | 246.707 |
| Airport_fee | 237.673 |
| passenger_count | 635.723 |

Dado o volume elevado (em `passenger_count`, por exemplo, os outliers representam mais de 20% da base), a regra de IQR não deve ser usada isoladamente para remoção de registros — o tratamento na staging deve focar nos casos fisicamente inconsistentes (valores negativos, zeros indevidos, datas invertidas), e não em todo outlier estatístico.

---

# Resultado

- Identificado um grupo consistente de **140.162 linhas** (~4,7% do total) sem informação em 5 colunas, associado ao `payment_type = 0` (Flex Fare) — não parece erro de carga, e sim um segmento de dados com esquema reduzido. Confirmado que os nulos das 5 colunas ocorrem exatamente nas mesmas linhas.
- **31.109 grupos** de possíveis registros duplicados identificados.
- **31.465 corridas** com `passenger_count = 0`, valor inconsistente.
- Identificados dois códigos distintos de "desconhecido" em `RatecodeID` (`NULL` e `99`).
- `VendorID` restrito a 3 códigos no período (1, 2 e 6); código 7 (Helix) ainda não operava.
- Diversas colunas monetárias (`fare_amount`, `tip_amount`, `tolls_amount`, `total_amount`, entre outras) apresentam **valores negativos**, e `trip_distance` chega a um máximo de 312.722,30 milhas — ambos inconsistentes e a serem tratados na staging.
- Distância média de 3,65 milhas (mediana 1,68) e tarifa média de US$ 18,18 (mediana US$ 12,80) — a diferença entre média e mediana confirma a presença de outliers.
- **56 corridas** com desembarque anterior ao embarque, concentradas principalmente no `VendorID = 6` (48 ocorrências).
- Análise de outliers via IQR aponta volume elevado em quase todas as colunas numéricas, indicando que a limpeza deve priorizar inconsistências físicas (negativos, zeros indevidos, datas invertidas) em vez de remoção baseada apenas em outlier estatístico.

---