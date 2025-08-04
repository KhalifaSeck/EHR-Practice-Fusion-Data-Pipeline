{{ config(materialized='view', schema='staging') }}

SELECT
    cast(LABRESULTGUID as STRING) as lab_result_id,
    cast(PATIENTGUID as STRING) as patient_id,
    cast(PRACTICEGUID as STRING) as practice_id,
    cast(FACILITYGUID as STRING) as facility_id,
    cast(TRANSCRIPTGUID as STRING) as transcript_id,
    cast(REPORTYEAR as INTEGER) as report_year,
    cast(ANCESTORLABRESULTGUID as STRING) as parent_result_id,
    cast(USERGUID as STRING) as user_id
FROM {{ source('RAW', 'LAB_RESULT') }}
