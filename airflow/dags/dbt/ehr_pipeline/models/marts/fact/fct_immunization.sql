{{ config(materialized='table', schema='marts') }}

SELECT
    p.patient_sk,
    v.vaccine_sk,
    im.administered_year
FROM {{ ref('stg_immunization') }} im
LEFT JOIN {{ ref('dim_patient') }} p
    ON im.patient_id = p.patient_id
LEFT JOIN {{ ref('dim_vaccine') }} v
    ON im.immunization_id = v.immunization_id