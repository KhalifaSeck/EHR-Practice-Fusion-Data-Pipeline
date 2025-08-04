{{ config(materialized='view', schema='staging') }}

SELECT
    cast(LABOBSERVATIONGUID as STRING) as lab_observation_id,
    cast(LABPANELGUID as STRING) as lab_panel_id,
    cast(HL7IDENTIFIER as STRING) as hl7_id,
    upper(trim(HL7TEXT)) as hl7_text,
    cast(
        CASE 
            WHEN upper(trim(HL7CODINGSYSTEM)) = 'L' THEN 'LabCorpLocal'
            ELSE HL7CODINGSYSTEM
        END as STRING
    ) as hl7_code_system,
    cast(ISLOINC as BOOLEAN) as is_loinc,
    cast(OBSERVATIONVALUE as STRING) as value,
    cast(ISVALIDVALUE as BOOLEAN) as is_valid,
    upper(trim(ABNORMALFLAGS)) as abnormal_flag,
    cast(ISABNORMALVALUE as BOOLEAN) as is_abnormal,
    cast(OBSERVATIONMETHOD as STRING) as method,
    cast(UNITS as STRING) as units,
    cast(OBSERVATIONYEAR as INTEGER) as observation_year
FROM {{ source('RAW', 'LAB_OBSERVATION') }}