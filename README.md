# Neuro-Symbolic-Framework-for-Fraud-Detection-Using-Knowledge-Representation

## Data

The raw IEEE-CIS Fraud Detection dataset is not included in this repository because of file size and licensing restrictions.

Download the dataset from Kaggle:

```text
IEEE-CIS Fraud Detection
https://www.kaggle.com/c/ieee-fraud-detection/data
```

After downloading, place the raw CSV files in:

```text
data/
```

Expected files:

```text
data/train_transaction.csv
data/train_identity.csv
data/test_transaction.csv
data/test_identity.csv
```

The main notebook expects this folder structure.

---

## Environment Setup

### 1. Clone the repository

```bash
git clone https://github.com/oar04/Neuro-Symbolic-Framework-for-Fraud-Detection-Using-Knowledge-Representationn.git
cd neuro-symbolic-fraud-detection
```

### 2. Install Python dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

A typical `requirements.txt` should contain:

```text
pandas
numpy
scikit-learn
xgboost
torch
matplotlib
seaborn
neo4j
owlready2
rdflib
networkx
jupyter
ipykernel
tqdm
joblib
```

---

## Neo4j Setup

Neo4j is used to construct the transaction graph and extract structural graph features.

### 1. Install Neo4j

Install either:

* Neo4j Desktop, or
* Neo4j Community/Enterprise Server

Neo4j Desktop is recommended for easier local setup.

---

### 2. Install the Neo4j Graph Data Science plugin

The project uses Neo4j Graph Data Science for graph analytics such as PageRank, degree and community detection.

In Neo4j Desktop:

1. Open your database.
2. Go to `Plugins`.
3. Install `Graph Data Science`.
4. Restart the database.

---

### 3. Configure Neo4j connection details

The notebook connects to Neo4j using a local database connection.

Default connection settings:

```text
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_password
```

You can either edit these directly in the notebook or store them in a local `.env` file.

Do not commit `.env` files to GitHub.

---

### 4. Load data into Neo4j

First run the notebook preprocessing cells to create cleaned data files for Neo4j import.

Then run the Cypher scripts in this order:

```text
cypher/create_graph.cypher
cypher/graph_features.cypher
cypher/export_features.cypher
```

These scripts are responsible for:

1. Creating transaction and entity nodes
2. Creating relationships between transactions and entities
3. Running graph algorithms
4. Exporting graph-derived features

The graph should include nodes such as:

```text
Transaction
Card
Device
Address
EmailDomain
Browser
OperatingSystem
```

and relationships such as:

```text
USES
BELONGS_TO
```

---

## Ontology and Reasoning Setup

The ontology component uses:

* Protégé for ontology development
* OWL for knowledge representation
* Owlready2 for Python integration
* Pellet for reasoning

The ontology file is stored in:

```text
ontology/fraud_ontology.owl
```

---

### 1. Install Java

Pellet requires Java.

Check Java is installed:

```bash
java -version
```

Install JDK-25.

---

### 2. Pellet reasoning

The notebook uses Owlready2 to run Pellet reasoning.

Because full OWL/SWRL reasoning over hundreds of thousands of transaction individuals is computationally expensive, Pellet reasoning is executed on a selected subset of transactions to validate the ontology and rule logic.

The same ontology-aligned rule logic is then applied deterministically across the full train and test sets as semantic features.

This avoids requiring Pellet to reason over the full dataset while still allowing ontology-derived features to be used in the machine learning pipeline.

---

### 3. Optional Pellet reasoning limit

You can control the number of rows used for Pellet validation with an environment variable:

```bash
set PELLET_REASONING_LIMIT=500
```

On macOS/Linux:

```bash
export PELLET_REASONING_LIMIT=500
```

A smaller value is faster and more stable. A larger value may take significantly longer or cause Java memory issues.

---

## Running the Full Project

The recommended way to run the project is through the notebook:

```text
notebooks/final_neuro_symbolic_fraud_detection.ipynb
```
