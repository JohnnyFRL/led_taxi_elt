# Staging - Tabela de Zonas

## Objetivo

A camada Staging tem como objetivo preparar os dados para a modelagem dimensional, mantendo uma separação entre os dados brutos (Raw) e os dados utilizados no Data Warehouse.

## Transformações realizadas

Durante o perfilamento da tabela `raw_zones` foi verificado que:

- Não existem valores nulos;
- Não existem registros duplicados;
- Não foram encontradas inconsistências nos dados.

Dessa forma, nenhuma regra adicional de limpeza foi necessária.

A tabela `stg_zones` foi criada utilizando `SELECT DISTINCT`, preservando todos os registros válidos da camada Raw.

## Script utilizado

```sql
DROP TABLE IF EXISTS stg_zones;

CREATE TABLE stg_zones AS
SELECT DISTINCT *
FROM raw_zones;
```

## Validação

```sql
SELECT COUNT(*) FROM raw_zones;

SELECT COUNT(*) FROM stg_zones;
```

Resultado:

| Tabela | Registros |
|--------|----------:|
| raw_zones | 265 |
| stg_zones | 265 |

## Conclusão

A tabela `stg_zones` manteve os 265 registros da camada Raw, não sendo necessária a remoção de registros ou aplicação de regras adicionais de tratamento.