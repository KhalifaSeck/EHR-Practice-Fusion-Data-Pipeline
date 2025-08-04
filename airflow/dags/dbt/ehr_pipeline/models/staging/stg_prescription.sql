{{ config(materialized='view', schema='staging') }}

SELECT
    cast(PRESCRIPTIONGUID as STRING) as prescription_id,
    cast(PATIENTGUID as STRING) as patient_id,
    cast(MEDICATIONGUID as STRING) as medication_id,
    CASE
        WHEN regexp_like(trim(QUANTITY), '^[0-9]+$')
            THEN cast(trim(QUANTITY) as INTEGER)
        WHEN upper(trim(QUANTITY)) = '(30) THIRTY' THEN 30
        WHEN upper(trim(QUANTITY)) = '1 PK' THEN 1
        ELSE NULL
    END as quantity,
    cast(PRESCRIPTIONYEAR as INTEGER) as prescription_year,
    CASE
        WHEN regexp_like(trim(NUMBEROFREFILLS), '^[0-9]+$')
            THEN cast(trim(NUMBEROFREFILLS) as INTEGER)
        WHEN upper(trim(NUMBEROFREFILLS)) IN ('ZERO', 'NULL') THEN 0
        WHEN upper(trim(NUMBEROFREFILLS)) = 'ONE' THEN 1
        ELSE NULL
    END as refills,
    cast(REFILLASNEEDED as BOOLEAN) as refill_as_needed,
    cast(GENERICALLOWED as BOOLEAN) as is_generic_allowed,
    cast(USERGUID as STRING) as user_id
FROM {{ source('RAW', 'PRESCRIPTION') }}