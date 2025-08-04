{{ config(materialized='table', schema='marts') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['medication_id']) }} AS medication_sk,
    medication_id,
    medication_name,
    ndc_code
FROM {{ ref('stg_medication') }}