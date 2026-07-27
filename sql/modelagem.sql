-- ESQUEMA ESTRELA


-- pra n fica aparecendo que ja existe

DROP TABLE IF EXISTS dim_localizacao;
DROP TABLE IF EXISTS dim_pagamento;
DROP TABLE IF EXISTS dim_tarifa;
DROP TABLE IF EXISTS dim_data;
DROP TABLE IF EXISTS fato_corridas;

-- Dimensionamento localização

CREATE TABLE dim_localizacao AS
SELECT
    LocationID,
    Borough,
    Zone,
    service_zone
FROM stg_zones;

-- Dimensionamento de pagamento

CREATE TABLE dim_pagamento AS
SELECT DISTINCT
    payment_type,
    CASE payment_type
        WHEN 1 THEN 'Credit Card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'No Charge'
        WHEN 4 THEN 'Dispute'
        WHEN 5 THEN 'Unknown'
        WHEN 6 THEN 'Voided Trip'
        ELSE 'Não informado'
    END AS descricao
FROM stg_taxi;

-- Dimensionamento de tarifa

CREATE TABLE dim_tarifa AS
SELECT DISTINCT
    RatecodeID,
    CASE RatecodeID
        WHEN 1 THEN 'Standard Rate'
        WHEN 2 THEN 'JFK'
        WHEN 3 THEN 'Newark'
        WHEN 4 THEN 'Nassau/Westchester'
        WHEN 5 THEN 'Negotiated Fare'
        WHEN 6 THEN 'Group Ride'
        WHEN 99 THEN 'Unknown'
        ELSE 'Não informado'
    END AS descricao
FROM stg_taxi;


-- Dimensionamento de data

CREATE TABLE dim_data AS
SELECT DISTINCT
    CAST(tpep_pickup_datetime AS DATE) AS data,
    YEAR(tpep_pickup_datetime) AS ano,
    MONTH(tpep_pickup_datetime) AS mes,
    DAY(tpep_pickup_datetime) AS dia,
    HOUR(tpep_pickup_datetime) AS hora,
    DAYNAME(tpep_pickup_datetime) AS dia_semana
FROM stg_taxi;

-- TABELA FATO

CREATE TABLE fato_corridas AS
SELECT
    VendorID,
    CAST(tpep_pickup_datetime AS DATE) AS data,
    payment_type,
    RatecodeID,
    PULocationID,
    DOLocationID,
    passenger_count,
    trip_distance,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    congestion_surcharge,
    Airport_fee,
    total_amount
FROM stg_taxi;