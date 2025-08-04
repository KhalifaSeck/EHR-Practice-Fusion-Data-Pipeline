{{ config(materialized='view', schema='staging') }}

SELECT
    cast(SMOKINGSTATUSGUID as STRING) as smoking_status_id,
    upper(trim(DESCRIPTION)) as description,
    cast(NISTCODE as INTEGER) as nist_code
FROM {{ source('RAW', 'SMOKING_STATUS') }}