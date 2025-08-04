{{ config(materialized='view', schema='staging') }}

SELECT
    cast(ALLERGYGUID as STRING) as allergy_id,
    cast(PATIENTGUID as STRING) as patient_id,
    upper(trim(ALLERGYTYPE)) as allergy_type,
    upper(trim(MEDICATIONNAME)) as medication_name,
    cast(MEDICATIONNDCCODE as STRING) as ndc_code,
    upper(trim(REACTIONNAME)) as reaction,
    upper(trim(SEVERITYNAME)) as severity,
    cast(STARTYEAR as INTEGER) as start_year,
    cast(USERGUID as STRING) as user_id
FROM {{ source('RAW', 'ALLERGY') }}
