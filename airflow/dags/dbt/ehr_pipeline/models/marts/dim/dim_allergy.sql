{{ config(materialized='table', schema='marts') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['allergy_id']) }} AS allergy_sk,
    allergy_id,
    allergy_type,
    severity,
    reaction
FROM {{ ref('stg_allergy') }}