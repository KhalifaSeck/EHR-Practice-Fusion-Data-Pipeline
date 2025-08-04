{{ config(materialized='table', schema='marts') }}

SELECT
    p.patient_sk,
    s.smoking_status_sk,
    ps.effective_year
FROM {{ ref('stg_patient_smoking_status') }} ps
LEFT JOIN {{ ref('dim_patient') }} p
    ON ps.patient_id = p.patient_id
LEFT JOIN {{ ref('dim_smoking_status') }} s
    ON ps.smoking_status_id = s.smoking_status_id