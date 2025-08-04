{{ config(materialized='table', schema='marts') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['immunization_id']) }} AS vaccine_sk,
    immunization_id,
    vaccine_name,
    cvx_code
FROM {{ ref('stg_immunization') }}