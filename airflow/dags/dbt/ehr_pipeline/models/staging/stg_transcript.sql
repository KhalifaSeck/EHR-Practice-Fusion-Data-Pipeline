{{ config(materialized='view', schema='staging') }}

SELECT
    cast(TRANSCRIPTGUID as STRING) as transcript_id,
    cast(PATIENTGUID as STRING) as patient_id,
    cast(VISITYEAR as INTEGER) as visit_year,
    cast(BMI as FLOAT) as bmi,
    cast(HEIGHT as FLOAT) as height,
    cast(SYSTOLICBP as INTEGER) as systolic_bp,
    cast(DIASTOLICBP as INTEGER) as diastolic_bp,
    cast(HEARTRATE as INTEGER) as heart_rate,
    cast(RESPIRATORYRATE as INTEGER) as respiratory_rate,
    cast(TEMPERATURE as FLOAT) as temperature,
    upper(trim(PHYSICIANSPECIALTY)) as physician_specialty,
    cast(USERGUID as STRING) as user_id
FROM {{ source('RAW', 'TRANSCRIPT') }}
