{{ config(materialized='table', schema='marts') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['practice_id']) }} AS practice_sk,
    practice_id,
    state
FROM {{ ref('stg_practice') }}