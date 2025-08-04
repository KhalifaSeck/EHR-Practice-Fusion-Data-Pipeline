{{ config(materialized='view', schema='staging') }}

SELECT
    cast(DIAGNOSISGUID as STRING) as diagnosis_id,
    cast(PATIENTGUID as STRING) as patient_id,
    cast(ICD9CODE as STRING) as diagnosis_code,
    upper(trim(DIAGNOSISDESCRIPTION)) as diagnosis_description,
    cast(STARTYEAR as INTEGER) as diagnosis_start_year,
    cast(STOPYEAR as INTEGER) as diagnosis_end_year,
    cast(ACUTE as BOOLEAN) as is_acute,
    cast(USERGUID as STRING) as user_id
FROM {{ source('RAW', 'DIAGNOSIS') }}
