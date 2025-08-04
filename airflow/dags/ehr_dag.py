from datetime import datetime
from airflow import DAG
from cosmos import (
    DbtRunLocalOperator,
    DbtTestLocalOperator,
    ProjectConfig,
    ProfileConfig,
    ExecutionConfig
)
from cosmos.profiles import SnowflakeUserPasswordProfileMapping

# ✅ Chemin vers le projet dbt dans le conteneur Astro
DBT_PROJECT_PATH = "/usr/local/airflow/dags/dbt/ehr_pipeline"

# 📌 Connexion à Snowflake
profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id="conn_ehr_pipeline",
        profile_args={
            "account": "", # Ajouter votre compte Snowflake
            "database": "EHR_PIPELINE",
            "schema": "dbt_schema",
            "role": "dbt_role"
        },
    )
)

# 🧠 dbt CLI (dans l'image Astro, "dbt" est dispo globalement)
execution_config = ExecutionConfig(dbt_executable_path="dbt")

# 🚀 DAG
with DAG(
    dag_id="dbt_snowflake_dags_ehr_pipeline",
    start_date=datetime(2023, 9, 10),
    schedule="@daily",
    catchup=False,
    tags=["dbt", "snowflake", "ehr_pipeline"],
    doc_md="""
    ### DAG dbt – EHR Pipeline
    Exécute : staging → dimensions → faits → tests
    """,
) as dag:

    dbt_run_staging = DbtRunLocalOperator(
        task_id="dbt_run_staging",
        project_dir=DBT_PROJECT_PATH,
        profile_config=profile_config,
        execution_config=execution_config,
        select="models/staging",
        install_deps=True,
    )

    dbt_run_dimensions = DbtRunLocalOperator(
        task_id="dbt_run_dimensions",
        project_dir=DBT_PROJECT_PATH,
        profile_config=profile_config,
        execution_config=execution_config,
        select="models/marts/dim",
    )

    dbt_run_facts = DbtRunLocalOperator(
        task_id="dbt_run_facts",
        project_dir=DBT_PROJECT_PATH,
        profile_config=profile_config,
        execution_config=execution_config,
        select="models/marts/fact",
    )

    dbt_test = DbtTestLocalOperator(
        task_id="dbt_test",
        project_dir=DBT_PROJECT_PATH,
        profile_config=profile_config,
        execution_config=execution_config,
    )

    # 📊 Dépendances
    dbt_run_staging >> dbt_run_dimensions >> dbt_run_facts >> dbt_test