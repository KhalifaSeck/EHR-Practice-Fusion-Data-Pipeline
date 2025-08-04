{{ config(materialized='view', schema='staging') }}

SELECT
    cast(PATIENTGUID as STRING) as patient_id,
    upper(trim(GENDER)) as gender,
    cast(PRACTICEGUID as STRING) as practice_id,
    upper(trim(STATE)) as state,
    cast(YEAROFBIRTH as INTEGER) as year_of_birth
FROM {{ source('RAW', 'PATIENT') }}