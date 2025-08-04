-- ingest_raw_data.sql
-- Script unique pour l'ingestion des données brutes EHR vers RAW
-- Exécuter dans SnowSQL uniquement

USE ROLE ACCOUNTADMIN;
USE DATABASE EHR_PIPELINE;
USE SCHEMA RAW;

-- Créer le stage avec format CSV
CREATE OR REPLACE STAGE ehr_stage 
FILE_FORMAT = (
    TYPE = CSV 
    FIELD_DELIMITER = ','
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
    TRIM_SPACE = TRUE
    NULL_IF = ('NULL', 'null', '', 'N/A')
    EMPTY_FIELD_AS_NULL = TRUE
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
);

-- Upload des fichiers CSV vers le stage
PUT file://ehr_pipeline/data/training_SyncAllergy.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncDiagnosis.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncImmunization.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncLabObservation.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncLabPanel.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncLabResult.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncMedication.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncPatient.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncPatientCondition.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncPatientSmokingStatus.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncPrescription.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/SyncSmokingStatus.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncTranscript.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncTranscriptAllergy.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncTranscriptDiagnosis.csv @ehr_stage AUTO_COMPRESS=FALSE;
PUT file://ehr_pipeline/data/training_SyncTranscriptMedication.csv @ehr_stage AUTO_COMPRESS=FALSE;

-- Vérifier que les fichiers sont bien uploadés
LIST @ehr_stage;

-- Ingestion des données brutes dans les tables RAW
COPY INTO RAW.ALLERGY FROM @ehr_stage/training_SyncAllergy.csv ON_ERROR = CONTINUE;
COPY INTO RAW.DIAGNOSIS FROM @ehr_stage/training_SyncDiagnosis.csv ON_ERROR = CONTINUE;
COPY INTO RAW.IMMUNIZATION FROM @ehr_stage/training_SyncImmunization.csv ON_ERROR = CONTINUE;
COPY INTO RAW.LAB_OBSERVATION FROM @ehr_stage/training_SyncLabObservation.csv ON_ERROR = CONTINUE;
COPY INTO RAW.LAB_PANEL FROM @ehr_stage/training_SyncLabPanel.csv ON_ERROR = CONTINUE;
COPY INTO RAW.LAB_RESULT FROM @ehr_stage/training_SyncLabResult.csv ON_ERROR = CONTINUE;
COPY INTO RAW.MEDICATION FROM @ehr_stage/training_SyncMedication.csv ON_ERROR = CONTINUE;
COPY INTO RAW.PATIENT FROM @ehr_stage/training_SyncPatient.csv ON_ERROR = CONTINUE;
COPY INTO RAW.PATIENT_CONDITION FROM @ehr_stage/training_SyncPatientCondition.csv ON_ERROR = CONTINUE;
COPY INTO RAW.PATIENT_SMOKING_STATUS FROM @ehr_stage/training_SyncPatientSmokingStatus.csv ON_ERROR = CONTINUE;
COPY INTO RAW.PRESCRIPTION FROM @ehr_stage/training_SyncPrescription.csv ON_ERROR = CONTINUE;
COPY INTO RAW.SMOKING_STATUS FROM @ehr_stage/SyncSmokingStatus.csv ON_ERROR = CONTINUE;
COPY INTO RAW.TRANSCRIPT FROM @ehr_stage/training_SyncTranscript.csv ON_ERROR = CONTINUE;
COPY INTO RAW.TRANSCRIPT_ALLERGY FROM @ehr_stage/training_SyncTranscriptAllergy.csv ON_ERROR = CONTINUE;
COPY INTO RAW.TRANSCRIPT_DIAGNOSIS FROM @ehr_stage/training_SyncTranscriptDiagnosis.csv ON_ERROR = CONTINUE;
COPY INTO RAW.TRANSCRIPT_MEDICATION FROM @ehr_stage/training_SyncTranscriptMedication.csv ON_ERROR = CONTINUE;

-- Vérification du nombre de lignes chargées par table
WITH table_counts AS (
    SELECT 'ALLERGY' AS table_name, COUNT(*) AS row_count FROM RAW.ALLERGY UNION ALL
    SELECT 'DIAGNOSIS', COUNT(*) FROM RAW.DIAGNOSIS UNION ALL
    SELECT 'IMMUNIZATION', COUNT(*) FROM RAW.IMMUNIZATION UNION ALL
    SELECT 'LAB_OBSERVATION', COUNT(*) FROM RAW.LAB_OBSERVATION UNION ALL
    SELECT 'LAB_PANEL', COUNT(*) FROM RAW.LAB_PANEL UNION ALL
    SELECT 'LAB_RESULT', COUNT(*) FROM RAW.LAB_RESULT UNION ALL
    SELECT 'MEDICATION', COUNT(*) FROM RAW.MEDICATION UNION ALL
    SELECT 'PATIENT', COUNT(*) FROM RAW.PATIENT UNION ALL
    SELECT 'PATIENT_CONDITION', COUNT(*) FROM RAW.PATIENT_CONDITION UNION ALL
    SELECT 'PATIENT_SMOKING_STATUS', COUNT(*) FROM RAW.PATIENT_SMOKING_STATUS UNION ALL
    SELECT 'PRESCRIPTION', COUNT(*) FROM RAW.PRESCRIPTION UNION ALL
    SELECT 'SMOKING_STATUS', COUNT(*) FROM RAW.SMOKING_STATUS UNION ALL
    SELECT 'TRANSCRIPT', COUNT(*) FROM RAW.TRANSCRIPT UNION ALL
    SELECT 'TRANSCRIPT_ALLERGY', COUNT(*) FROM RAW.TRANSCRIPT_ALLERGY UNION ALL
    SELECT 'TRANSCRIPT_DIAGNOSIS', COUNT(*) FROM RAW.TRANSCRIPT_DIAGNOSIS UNION ALL
    SELECT 'TRANSCRIPT_MEDICATION', COUNT(*) FROM RAW.TRANSCRIPT_MEDICATION
)
SELECT 
    table_name,
    row_count,
    CASE 
        WHEN row_count = 0 THEN '⚠️  EMPTY'
        WHEN row_count > 0 THEN '✅ LOADED'
    END AS status
FROM table_counts
ORDER BY row_count DESC, table_name;