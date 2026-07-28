# 🚖 Projeto ELT - NYC Taxi Trips

Projeto de Engenharia de Dados desenvolvido para a disciplina de **Laboratório de Engenharia de Dados (LED)** da **Universidade Federal de Pernambuco (UFPE)**.

O projeto implementa um pipeline **ELT (Extract, Load and Transform)** utilizando **DuckDB** e **SQL**, contemplando as etapas de extração, carregamento, perfilamento, transformação, modelagem dimensional e análise dos dados de corridas de táxi amarelo da cidade de Nova York.

Além dos scripts SQL, o projeto inclui um **notebook Jupyter** utilizado para exploração inicial dos dados, perfilamento, validação das transformações e apoio às análises realizadas durante o desenvolvimento.

Durante a etapa de transformação foram realizadas operações de limpeza dos dados, incluindo a remoção de registros duplicados, inconsistências temporais, distâncias inválidas e registros com valores nulos considerados inadequados para o escopo das análises.

---

# 📂 Estrutura do Projeto

```text
.
├── data/
│   ├── yellow_tripdata_2024-01.parquet
│   └── taxi_zone_lookup.csv
│
├── docs/
│   └── documentacao_modelagem.md
│
├── ipynb/
│   └── elt_nyc_taxi.ipynb
│
├── sql/
│   ├── 01_raw.sql
│   ├── 02_staging.sql
│   ├── 03_modelagem.sql
│   └── 04_analises.sql
│
├── README.md
└── .gitignore
```

### 📘 Notebook

A pasta `ipynb/` contém o notebook **elt_nyc_taxi.ipynb**, utilizado para:

* exploração inicial do dataset;
* análise de qualidade dos dados;
* perfilamento estatístico;
* validação das regras de transformação;
* testes de consultas analíticas.

---

# 🛠 Tecnologias Utilizadas

* DuckDB
* SQL
* Jupyter Notebook
* Python
* Arquivos Parquet
* Arquivos CSV

---

# 🔄 Pipeline ELT

O projeto foi desenvolvido seguindo as seguintes etapas:

## 1. Extract

* Leitura dos arquivos Parquet e CSV.

## 2. Raw

* Criação das tabelas brutas (`raw_taxi` e `raw_zones`).

## 3. Data Profiling

Foram realizadas análises para identificar:

* valores nulos;
* registros duplicados;
* distribuição dos dados;
* inconsistências;
* outliers.

## 4. Staging (Transformação)

Nesta etapa foram realizados:

* remoção de registros duplicados;
* remoção de distâncias inválidas;
* remoção de corridas com horários inconsistentes;
* remoção de registros contendo valores nulos considerados inválidos para o projeto.

Após a limpeza foram criadas as tabelas:

* `stg_taxi`
* `stg_zones`

## 5. Modelagem Dimensional

Foi implementado um **Esquema Estrela (Star Schema)** composto por:

### Tabelas Dimensão

* `dim_data`
* `dim_localizacao`
* `dim_pagamento`
* `dim_tarifa`

### Tabela Fato

* `fato_corridas`

## 6. Análises

Foram desenvolvidas consultas analíticas utilizando a tabela fato e as dimensões para responder diferentes questões sobre as corridas de táxi.

---

# ▶️ Como Executar

## 1. Clone o repositório

```bash
git clone <URL_DO_REPOSITORIO>
cd led_taxi_elt
```

## 2. Baixe o dataset

Faça o download dos seguintes arquivos do conjunto de dados **NYC TLC Trip Record Data**:

* `yellow_tripdata_2024-01.parquet`
* `taxi_zone_lookup.csv`

Copie ambos para a pasta:

```text
data/
```

## 3. Execute os scripts SQL na ordem

```text
01_raw.sql
02_staging.sql
03_modelagem.sql
04_analises.sql
```

Ao final da execução será criado o banco de dados **database.duckdb** contendo todas as tabelas do projeto.

## 4. Abrir o notebook (opcional)

Para reproduzir a exploração e o perfilamento dos dados:

```bash
jupyter notebook ipynb/elt_nyc_taxi.ipynb
```

---

# 🗂 Estrutura do Banco

```text
database.duckdb

raw_taxi
raw_zones

stg_taxi
stg_zones

dim_data
dim_localizacao
dim_pagamento
dim_tarifa

fato_corridas
```

---

# 📊 Dataset

O projeto utiliza dados públicos disponibilizados pela **New York City Taxi and Limousine Commission (TLC)**.

Arquivos utilizados:

* `yellow_tripdata_2024-01.parquet`
* `taxi_zone_lookup.csv`

---

# 📌 Observações

O arquivo `database.duckdb` não foi versionado neste repositório porque seu tamanho excede o limite permitido pelo GitHub para arquivos individuais.

Para reproduzir o projeto, basta adicionar os arquivos do dataset na pasta do projeto e executar os scripts SQL na ordem apresentada.

O notebook Jupyter é opcional e foi incluído apenas para fins de exploração e documentação do processo analítico.

---

# 👨‍💻 Autores

Projeto desenvolvido para a disciplina de **Laboratório de Engenharia de Dados (LED)** da **Universidade Federal de Pernambuco (UFPE)**.

**Integrantes:**

* Johnny Cleiton Ferreira Lins
* Vinicius Pena
