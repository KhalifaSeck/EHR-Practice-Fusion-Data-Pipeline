{{ config(materialized='table', schema='marts') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['patient_id']) }} AS patient_sk,
    patient_id,
    gender,
    year_of_birth,
    state,
    practice_id
FROM {{ ref('stg_patient') }}