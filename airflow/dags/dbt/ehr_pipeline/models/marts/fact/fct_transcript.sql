{{ config(materialized='table', schema='marts') }}

SELECT
    t.transcript_id,
    p.patient_sk,
    t.visit_year,
    t.bmi,
    t.systolic_bp,
    t.diastolic_bp,
    t.heart_rate,
    t.respiratory_rate,
    t.temperature,
    t.physician_specialty
FROM {{ ref('stg_transcript') }} t
LEFT JOIN {{ ref('dim_patient') }} p
    ON t.patient_id = p.patient_id