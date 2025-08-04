{{ config(materialized='view', schema='staging') }}

SELECT
    cast(MEDICATIONGUID as STRING) as medication_id,
    upper(trim(MEDICATIONNAME)) as medication_name,
    cast(NDCCODE as STRING) as ndc_code
FROM {{ source('RAW', 'MEDICATION') }}