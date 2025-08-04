{{ config(materialized='view', schema='staging') }}

SELECT
    cast(PRACTICEGUID as STRING) as practice_id,
    upper(trim(STATE)) as state
FROM {{ source('RAW', 'PATIENT') }}