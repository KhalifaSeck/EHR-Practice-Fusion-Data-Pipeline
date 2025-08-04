{{ config(materialized='table', schema='marts') }}

SELECT
    p.patient_sk,
    d.diagnosis_sk,
    diag.diagnosis_start_year,
    diag.diagnosis_end_year,
    diag.is_acute
FROM {{ ref('stg_diagnosis') }} diag
LEFT JOIN {{ ref('dim_patient') }} p
    ON diag.patient_id = p.patient_id
LEFT JOIN {{ ref('dim_diagnosis') }} d
    ON diag.diagnosis_id = d.diagnosis_id