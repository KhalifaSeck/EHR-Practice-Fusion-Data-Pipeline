-- ======================================
-- SCRIPT 1: CRÉATION DES TABLES EHR
-- ======================================
-- Exécuter ce script en premier pour créer la structure

USE ROLE ACCOUNTADMIN;
USE DATABASE ehr_pipeline;
USE SCHEMA RAW;

-- ======================================
-- CRÉATION DE TOUTES LES TABLES
-- ======================================

CREATE OR REPLACE TABLE RAW.ALLERGY (
  AllergyGuid STRING,
  PatientGuid STRING,
  AllergyType STRING,
  StartYear NUMBER,
  ReactionName STRING,
  SeverityName STRING,
  MedicationNdcCode STRING,
  MedicationName STRING,
  UserGuid STRING
);

CREATE OR REPLACE TABLE RAW.CONDITION (
  ConditionGuid STRING,
  Code STRING,
  Name STRING
);

CREATE OR REPLACE TABLE RAW.DIAGNOSIS (
  DiagnosisGuid STRING,
  PatientGuid STRING,
  ICD9Code STRING,
  DiagnosisDescription STRING,
  StartYear NUMBER,
  StopYear NUMBER,
  Acute BOOLEAN,
  UserGuid STRING
);

CREATE OR REPLACE TABLE RAW.IMMUNIZATION (
  ImmunizationGuid STRING,
  PatientGuid STRING,
  VaccineName STRING,
  AdministeredYear NUMBER,
  CvxCode STRING,
  UserGuid STRING
);

CREATE OR REPLACE TABLE RAW.LAB_OBSERVATION (
  LabObservationGuid STRING,
  LabPanelGuid STRING,
  HL7Identifier STRING,
  HL7Text STRING,
  HL7CodingSystem STRING,
  IsLoinc BOOLEAN,
  ObservationValue STRING,
  IsValidValue BOOLEAN,
  Units STRING,
  ReferenceRange STRING,
  AbnormalFlags STRING,
  ResultStatus STRING,
  ObservationYear NUMBER,
  ObservationMethod STRING,
  UserGuid STRING,
  IsAbnormalValue BOOLEAN,
  Sequence NUMBER
);

CREATE OR REPLACE TABLE RAW.LAB_PANEL (
  LabPanelGuid STRING,
  LabResultGuid STRING,
  PanelName STRING,
  ObservationYear NUMBER,
  DangerCode STRING,
  Status STRING,
  Sequence NUMBER
);

CREATE OR REPLACE TABLE RAW.LAB_RESULT (
  LabResultGuid STRING,
  UserGuid STRING,
  PatientGuid STRING,
  TranscriptGuid STRING,
  PracticeGuid STRING,
  FacilityGuid STRING,
  ReportYear NUMBER,
  AncestorLabResultGuid STRING
);

CREATE OR REPLACE TABLE RAW.MEDICATION (
  MedicationGuid STRING,
  PatientGuid STRING,
  NdcCode STRING,
  MedicationName STRING,
  MedicationStrength STRING,
  Schedule STRING,
  DiagnosisGuid STRING,
  UserGuid STRING
);

CREATE OR REPLACE TABLE RAW.PATIENT (
  PatientGuid STRING,
  Gender STRING,
  YearOfBirth NUMBER,
  State STRING,
  PracticeGuid STRING
);

CREATE OR REPLACE TABLE RAW.PATIENT_CONDITION (
  PatientConditionGuid STRING,
  PatientGuid STRING,
  ConditionGuid STRING,
  CreatedYear NUMBER
);

CREATE OR REPLACE TABLE RAW.PATIENT_SMOKING_STATUS (
  PatientSmokingStatusGuid STRING,
  PatientGuid STRING,
  SmokingStatusGuid STRING,
  EffectiveYear NUMBER
);

CREATE OR REPLACE TABLE RAW.PRESCRIPTION (
  PrescriptionGuid STRING,
  PatientGuid STRING,
  MedicationGuid STRING,
  PrescriptionYear NUMBER,
  Quantity STRING,
  NumberOfRefills STRING,
  RefillAsNeeded BOOLEAN,
  GenericAllowed BOOLEAN,
  UserGuid STRING
);

CREATE OR REPLACE TABLE RAW.SMOKING_STATUS (
  SmokingStatusGuid STRING,
  Description STRING,
  NISTcode NUMBER
);

CREATE OR REPLACE TABLE RAW.TRANSCRIPT (
  TranscriptGuid STRING,
  PatientGuid STRING,
  VisitYear NUMBER,
  Height FLOAT,
  Weight FLOAT,
  BMI FLOAT,
  SystolicBP NUMBER,
  DiastolicBP NUMBER,
  RespiratoryRate NUMBER,
  HeartRate NUMBER,
  Temperature FLOAT,
  PhysicianSpecialty STRING,
  UserGuid STRING
);

CREATE OR REPLACE TABLE RAW.TRANSCRIPT_ALLERGY (
  TranscriptAllergyGuid STRING,
  TranscriptGuid STRING,
  AllergyGuid STRING,
  DisplayOrder NUMBER
);

CREATE OR REPLACE TABLE RAW.TRANSCRIPT_DIAGNOSIS (
  TranscriptDiagnosisGuid STRING,
  TranscriptGuid STRING,
  DiagnosisGuid STRING,
  OrderBy NUMBER
);

CREATE OR REPLACE TABLE RAW.TRANSCRIPT_MEDICATION (
  TranscriptMedicationGuid STRING,
  TranscriptGuid STRING,
  MedicationGuid STRING,
  OrderBy NUMBER
);

-- ======================================
-- VÉRIFICATION DES TABLES CRÉÉES
-- ======================================
SHOW TABLES IN SCHEMA RAW;

-- Compter le nombre de tables créées
SELECT COUNT(*) AS tables_created 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'RAW' 
AND TABLE_CATALOG = 'EHR_PIPELINE';

SELECT '✅ Tables créées avec succès!' AS status;