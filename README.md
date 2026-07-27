<<<<<<< HEAD
# led_taxi_elt
Projeto de Engenharia de Dados desenvolvido para a LED-UFPE. Implementação de um pipeline ELT com DuckDB e SQL, incluindo ingestão, tratamento, modelagem dimensional e análises sobre dados de corridas de táxi de Nova York.
=======
# 🚖 Projeto ELT - NYC Taxi Trips

Projeto de Engenharia de Dados desenvolvido para a disciplina da **LED - UFPE**.

O projeto implementa um pipeline **ELT (Extract, Load and Transform)** utilizando **DuckDB** e **SQL**, abrangendo as etapas de extração, carregamento, perfilamento, transformação, modelagem dimensional e análise dos dados de corridas de táxi amarelo da cidade de Nova York.

Durante a etapa de transformação foram realizadas operações de limpeza dos dados, incluindo a remoção de registros duplicados, inconsistências temporais, distâncias inválidas e registros com valores nulos considerados inadequados para o escopo das análises.

---

## 📂 Estrutura do projeto

```
.
├── data/
│   ├── yellow_tripdata_2024-01.parquet
│   └── taxi_zone_lookup.csv
│
├── sql/
│   ├── 01_raw.sql
│   ├── 02_staging.sql
│   ├── 03_modelagem.sql
│   └── 04_analises.sql
│
├── docs/
├── database.duckdb
└── README.md
```

---

## 🛠 Tecnologias utilizadas

- DuckDB
- SQL
- Arquivos Parquet
- Arquivos CSV

---

## 🔄 Pipeline ELT

O projeto foi desenvolvido seguindo as seguintes etapas:

1. **Extract**
   - Leitura dos arquivos Parquet e CSV.

2. **Raw**
   - Criação das tabelas brutas sem alterações.

3. **Data Profiling**
   - Identificação de valores nulos.
   - Verificação de duplicatas.
   - Análise de distribuições.
   - Identificação de inconsistências.

4. **Staging (Transformação)**
   - Remoção de registros duplicados.
   - Remoção de distâncias inválidas.
   - Remoção de corridas com horários inconsistentes.
   - Remoção de registros com valores nulos definidos como inválidos para o projeto.

5. **Modelagem Dimensional**
   - Construção do modelo estrela (Star Schema).
   - Criação das tabelas fato e dimensões.

6. **Análise**
   - Consultas analíticas para extração de informações sobre as corridas.

---

## ▶️ Como executar

### 1. Clone o repositório

```bash
git clone <URL_DO_REPOSITORIO>
cd led_taxi_elt
```

### 2. Baixe o dataset

Faça o download dos seguintes arquivos do conjunto de dados **NYC TLC Trip Record Data**:

- `yellow_tripdata_2024-01.parquet`
- `taxi_zone_lookup.csv`

Copie ambos para a pasta:

```
data/
```

### 3. Execute os scripts SQL na ordem

```text
01_raw.sql
02_staging.sql
03_modelagem.sql
04_analises.sql
```

O banco **database.duckdb** será criado automaticamente durante a execução dos scripts.

---

## 📌 Observações

O arquivo `database.duckdb` não foi incluído no repositório porque seu tamanho excede o limite de arquivos permitido pelo GitHub.

Por esse motivo, o banco deve ser gerado localmente executando os scripts SQL do projeto após adicionar os arquivos do dataset na pasta `data/`.

---

## 📊 Dataset

O projeto utiliza dados públicos disponibilizados pelo **NYC Taxi & Limousine Commission (TLC)**.

Arquivos utilizados:

- `yellow_tripdata_2024-01.parquet`
- `taxi_zone_lookup.csv`

---

## 👨‍💻 Autores

Projeto desenvolvido para a disciplina de Engenharia de Dados (LED - UFPE).
>>>>>>> f5c8340eb7da15dad5d74984fd784f110cd04a0c
