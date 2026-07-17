CREATE TABLE raw_taxi AS
SELECT *
FROM read_parquet('data/yellow_tripdata_2024-01.parquet');

CREATE TABLE raw_zones AS
SELECT *
FROM read_csv_auto('data/taxi_zone_lookup.csv');