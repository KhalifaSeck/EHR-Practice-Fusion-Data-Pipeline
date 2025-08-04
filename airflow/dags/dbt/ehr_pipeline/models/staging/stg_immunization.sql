{{ config(materialized='view', schema='staging') }}

SELECT
    cast(IMMUNIZATIONGUID as STRING) as immunization_id,
    upper(trim(VACCINENAME)) as vaccine_name,
    cast(CVXCODE as STRING) as cvx_code,
    cast(PATIENTGUID as STRING) as patient_id,
    cast(ADMINISTEREDYEAR as INTEGER) as administered_year
FROM {{ source('RAW', 'IMMUNIZATION') }}