# 📐 README – Configuration et utilisation de dbt

Ce document décrit la mise en place et l’utilisation de **dbt** pour le projet **EHR Practice Fusion Data Pipeline**.

---

## 🎯 Objectifs dbt

* **Standardiser** les données brutes (`RAW`) via des vues **staging**.
* **Construire** des tables de **dimensions** et de **faits** dans le schéma `MARTS`.
* **Documenter** et **tester** chaque modèle avec `schema.yml`.

---

## ⚙️ Configuration principale

### dbt\_project.yml

* **schéma STAGING** pour `models/staging` (materialized as `view`).
* **schéma MARTS** pour `models/marts` (materialized as `table`).

```yaml
name: 'ehr_pipeline'
version: '1.0.0'

models:
  ehr_pipeline:
    staging:
      +schema: STAGING
      +materialized: view

    marts:
      +schema: MARTS
      +materialized: table
      dim:
        +schema: MARTS
      fact:
        +schema: MARTS
```

### profiles.yml

* Utiliser des variables d’environnement (`.env` ou CI secrets).
* Ne jamais committer d’identifiants en clair.

```yaml
ehr_pipeline:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: lw87791.ca-central-1.aws
      user: "{{ env_var('SNOWFLAKE_USER') }}"
      password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
      role: dbt_role
      database: EHR_PIPELINE
      warehouse: ehr_wh
      schema: STAGING
      threads: 4
```

---

## 🚀 Commandes courantes

```bash
# Installer les dépendances (si packages.yml)
dbt deps

# Exécuter tous les modèles (staging + marts)
dbt run

# Exécuter uniquement le staging
dbt run --select models/staging

# Exécuter uniquement les dimensions
dbt run --select models/marts/dim

# Exécuter uniquement les faits
dbt run --select models/marts/fact

# Lancer les tests
dbt test

# Générer la documentation et la servir localement
dbt docs generate
dbt docs serve
```

---

## 🔍 Documentation & tests

* Le fichier `schema.yml` contient :

  * la **définition** des sources (`RAW` schema).
  * la **documentation** des colonnes pour tous les modèles.
  * les **tests** : `unique`, `not_null`, `relationships`.

* Utiliser `dbt test` pour valider la qualité des données après chaque transformation.

---

## 🛠️ Bonnes pratiques

* **Modularité** : un fichier SQL par modèle, nommés `stg_*.sql`, `dim_*.sql`, `fct_*.sql`.
* **Documentation** : chaque modèle référencé dans `schema.yml`.
* **Versions** : taguer les releases dbt (Git tags) pour reproduire les états.

---

> **Auteur :** Khalifa Ababacar Seck
> **Projet :** EHR Practice Fusion Data Pipeline
