CREATE TABLE stg_taxi AS
SELECT DISTINCT *
FROM raw_taxi
WHERE
    trip_distance > 0
    AND tpep_dropoff_datetime > tpep_pickup_datetime
    AND passenger_count IS NOT NULL;