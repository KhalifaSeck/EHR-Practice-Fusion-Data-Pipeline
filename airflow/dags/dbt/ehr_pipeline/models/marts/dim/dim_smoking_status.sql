{{ config(materialized='table', schema='marts') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['smoking_status_id']) }} AS smoking_status_sk,
    smoking_status_id,
    description,
    nist_code
FROM {{ ref('stg_smoking_status') }}