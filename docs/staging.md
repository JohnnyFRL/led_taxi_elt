# Transformação dos Dados

## Objetivo

A camada de Staging teve como objetivo preparar os dados da camada Raw após o perfilamento para utilização na modelagem dimensional.

## Regras aplicadas

Foram realizadas as seguintes transformações:

- Remoção de registros duplicados (`SELECT DISTINCT`);
- Remoção de viagens com distância menor ou igual a zero;
- Remoção de viagens com horário de desembarque menor ou igual ao horário de embarque;
- Remoção de registros com valores nulos em `passenger_count`.

## Resultado

Foi criada a tabela `stg_taxi`, contendo apenas registros considerados válidos para a etapa de modelagem.