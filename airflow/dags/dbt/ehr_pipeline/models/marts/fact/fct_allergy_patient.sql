{{ config(materialized='table', schema='marts') }}

SELECT
    p.patient_sk,
    a.allergy_sk,
    al.severity,
    al.start_year
FROM {{ ref('stg_allergy') }} al
LEFT JOIN {{ ref('dim_patient') }} p
    ON al.patient_id = p.patient_id
LEFT JOIN {{ ref('dim_allergy') }} a
    ON al.allergy_id = a.allergy_id