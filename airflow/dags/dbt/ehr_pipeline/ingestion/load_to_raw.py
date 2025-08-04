import os
from dotenv import load_dotenv
import snowflake.connector

# Chargement du fichier .env
load_dotenv()

# Connexion sécurisée à Snowflake via variables d’environnement
conn = snowflake.connector.connect(
    user=os.getenv('SNOWFLAKE_USER'),
    password=os.getenv('SNOWFLAKE_PASSWORD'),
    account=os.getenv('SNOWFLAKE_ACCOUNT'),
    warehouse=os.getenv('SNOWFLAKE_WAREHOUSE'),
    database=os.getenv('SNOWFLAKE_DATABASE'),
    schema=os.getenv('SNOWFLAKE_SCHEMA'),
    role=os.getenv('SNOWFLAKE_ROLE')
)

cursor = conn.cursor()

# Dossier contenant les fichiers CSV
DATA_DIR = '.ehr_pipeline/data'

# Mapping fichier → table cible RAW
mapping = {
    'training_SyncAllergy.csv': 'ALLERGY',
    'training_SyncDiagnosis.csv': 'DIAGNOSIS',
    'training_SyncImmunization.csv': 'IMMUNIZATION',
    'training_SyncLabObservation.csv': 'LABOBSERVATION',
    'training_SyncLabPanel.csv': 'LABPANEL',
    'training_SyncLabResult.csv': 'LABRESULT',
    'training_SyncMedication.csv': 'MEDICATION',
    'training_SyncPatient.csv': 'PATIENT',
    'training_SyncPatientCondition.csv': 'PATIENTCONDITION',
    'training_SyncPatientSmokingStatus.csv': 'PATIENTSMOKINGSTATUS',
    'training_SyncPrescription.csv': 'PRESCRIPTION',
    'training_SyncSmokingStatus.csv': 'SMOKINGSTATUS',
    'training_SyncTranscript.csv': 'TRANSCRIPT',
    'training_SyncTranscriptAllergy.csv': 'TRANSCRIPTALLERGY',
    'training_SyncTranscriptDiagnosis.csv': 'TRANSCRIPTDIAGNOSIS',
    'training_SyncTranscriptMedication.csv': 'TRANSCRIPTMEDICATION',
}

# Chargement automatisé de chaque fichier
for filename, tablename in mapping.items():
    local_path = os.path.join(DATA_DIR, filename)
    print(f"📤 Uploading {filename} to RAW.{tablename}...")

    # Étape 1 - Upload dans le stage
    put_command = f"""
        PUT file://{local_path} @ehr_local_stage AUTO_COMPRESS=TRUE
    """
    cursor.execute(put_command)

    # Étape 2 - COPY INTO table RAW depuis le stage compressé
    copy_command = f"""
        COPY INTO {tablename}
        FROM @ehr_local_stage/{filename}.csv
        FILE_FORMAT = (TYPE = CSV FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1)
        ON_ERROR = CONTINUE
    """
    cursor.execute(copy_command)

    # Étape 3 - Nettoyage du fichier dans le stage
    cursor.execute(f"REMOVE @ehr_local_stage/{filename}.csv")

print("✅ Tous les fichiers ont été chargés dans RAW.")
