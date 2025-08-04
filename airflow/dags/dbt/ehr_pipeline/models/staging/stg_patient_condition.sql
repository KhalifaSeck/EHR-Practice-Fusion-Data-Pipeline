{{ config(materialized='view', schema='staging') }}

SELECT
    cast(PATIENTCONDITIONGUID as STRING) as patient_condition_id,
    cast(PATIENTGUID as STRING) as patient_id,
    cast(CONDITIONGUID as STRING) as condition_id,
    cast(CREATEDYEAR as INTEGER) as created_year
FROM {{ source('RAW', 'PATIENT_CONDITION') }}
