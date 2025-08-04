{{ config(materialized='table', schema='marts') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['diagnosis_id']) }} AS diagnosis_sk,
    diagnosis_id,
    diagnosis_code,
    diagnosis_description,
    is_acute
FROM {{ ref('stg_diagnosis') }}