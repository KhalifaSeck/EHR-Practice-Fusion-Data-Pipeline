{{ config(materialized='table', schema='marts') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['lab_observation_id']) }} AS lab_test_sk,
    lab_observation_id,
    hl7_id,
    hl7_text,
    method,
    units
FROM {{ ref('stg_lab_observation') }}