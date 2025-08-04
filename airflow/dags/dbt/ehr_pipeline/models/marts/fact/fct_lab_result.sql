{{ config(materialized='table', schema='marts') }}

SELECT
    p.patient_sk,
    l.lab_test_sk,
    lab.observation_year,
    lab.value,
    lab.abnormal_flag,
    lab.is_abnormal
FROM {{ ref('stg_lab_observation') }} lab
LEFT JOIN {{ ref('stg_lab_result') }} lr
    ON lab.lab_panel_id = lr.lab_result_id
LEFT JOIN {{ ref('dim_patient') }} p
    ON lr.patient_id = p.patient_id
LEFT JOIN {{ ref('dim_lab_test') }} l
    ON lab.lab_observation_id = l.lab_observation_id