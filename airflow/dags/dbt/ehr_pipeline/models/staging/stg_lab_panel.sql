{{ config(materialized='view', schema='staging') }}

SELECT
    cast(LABPANELGUID as STRING) as lab_panel_id,
    cast(LABRESULTGUID as STRING) as lab_result_id,
    upper(trim(PANELNAME)) as panel_name,
    cast(OBSERVATIONYEAR as INTEGER) as observation_year,
    upper(trim(DANGERCODE)) as danger_code,
    cast(SEQUENCE as INTEGER) as sequence,
    upper(trim(STATUS)) as status
FROM {{ source('RAW', 'LAB_PANEL') }}
