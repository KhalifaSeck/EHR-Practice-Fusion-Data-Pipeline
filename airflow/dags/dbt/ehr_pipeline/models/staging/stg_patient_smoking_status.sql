{{ config(materialized='view', schema='staging') }}

SELECT
    cast(PATIENTSMOKINGSTATUSGUID as STRING) as patient_smoking_status_id,
    cast(PATIENTGUID as STRING) as patient_id,
    cast(SMOKINGSTATUSGUID as STRING) as smoking_status_id,
    cast(EFFECTIVEYEAR as INTEGER) as effective_year
FROM {{ source('RAW', 'PATIENT_SMOKING_STATUS') }}