# 🛠️ Orchestration Airflow

> **Pré-requis** : Copier le dossier `dbt/ehr_pipeline` dans `dags/dbt/ehr_pipeline` du conteneur Airflow pour garantir que le projet dbt est accessible aux DAGs.

L’orchestration est assurée par **Apache Airflow** avec l’opérateur Cosmos :

* **dbt\_run\_staging** : exécute les modèles de nettoyage dans le schéma `STAGING`.
* **dbt\_run\_dimensions** : exécute les modèles de dimensions dans le schéma `MARTS`.
* **dbt\_run\_facts** : exécute les modèles de faits dans le schéma `MARTS`.
* **dbt\_test** : lance les tests dbt sur tous les modèles déployés.

---

## 🛠️ 4.1 Étapes d’implémentation du DAG Airflow

1. **Définition des connexions**

   * Créer une connexion Snowflake (`conn_ehr_pipeline`) dans l’UI Airflow.
   * Configurer host, login, mot de passe, entrepôt et rôle via les variables ou secrets Airflow.

2. **Configuration du ProfileConfig**

   * Utiliser `ProfileConfig` et `SnowflakeUserPasswordProfileMapping` pour pointer vers la connexion Airflow.
   * Spécifier dynamiquement `database`, `schema`, `role` et `account`.

3. **Construction du DAG**

   * Instancier un DAG Airflow avec `schedule='@daily'`, `catchup=False` et tags adaptés.
   * Définir quatre tâches : `DbtRunLocalOperator` pour `staging`, `dimensions`, `facts`, et `DbtTestLocalOperator`.

4. **Gestion des dépendances**

   * Chaîner les opérateurs dans l’ordre : staging → dimensions → faits → tests.
   * S’assurer que `install_deps=True` sur la première tâche pour installer les packages dbt.

5. **Monitoring et alerting**

   * Configurer des alertes (e-mail ou Slack) en cas d’échec de tâche via les callbacks Airflow.
   * Consulter les logs et XComs pour diagnostiquer les erreurs dbt.

6. **Test et déploiement**

   * Valider localement avec la CLI Airflow (`airflow tasks test`).
   * Déployer le DAG sur le serveur Airflow et surveiller les exécutions planifiées.
