{{ config(materialized='table', schema='marts') }}

SELECT
    p.patient_sk,
    m.medication_sk,
    pr.prescription_year,
    pr.quantity,
    pr.refills,
    pr.is_generic_allowed
FROM {{ ref('stg_prescription') }} pr
LEFT JOIN {{ ref('dim_patient') }} p
    ON pr.patient_id = p.patient_id
LEFT JOIN {{ ref('dim_medication') }} m
    ON pr.medication_id = m.medication_id
WHERE pr.quantity IS NOT NULL