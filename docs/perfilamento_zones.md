# Perfilamento da Tabela de Zonas (raw_zones)

## Objetivo

O objetivo do perfilamento foi verificar a integridade e a qualidade dos dados da tabela `raw_zones`, utilizada como tabela de referência para identificação das zonas de embarque e desembarque das viagens de táxi.

## Verificações realizadas

### Quantidade de registros

| Métrica | Resultado |
|---------|-----------|
| Total de registros | 265 |

A quantidade de registros está de acordo com o esperado para a tabela de zonas do sistema de táxis de Nova York.

---

### Valores nulos

| Coluna | Valores nulos |
|---------|---------------|
| LocationID | 0 |
| Borough | 0 |
| Zone | 0 |
| service_zone | 0 |

Não foram encontrados valores nulos em nenhuma das colunas da tabela.

---

### Registros duplicados

Foi realizada a verificação de duplicidade da chave `LocationID`.

Resultado:

- Nenhum registro duplicado encontrado.

---

### Distribuição por Borough

| Borough | Quantidade |
|----------|-----------:|
| Manhattan | 69 |
| Queens | 69 |
| Brooklyn | 61 |
| Bronx | 43 |
| Staten Island | 20 |
| EWR | 1 |
| Unknown | 1 |
| N/A | 1 |

Observa-se que Manhattan e Queens possuem a maior quantidade de zonas cadastradas.

---

### Distribuição por Service Zone

| Service Zone | Quantidade |
|--------------|-----------:|
| Boro Zone | 205 |
| Yellow Zone | 55 |
| Airports | 2 |
| N/A | 2 |
| EWR | 1 |

A maior parte das zonas pertence à categoria **Boro Zone**.

---

## Conclusão

A tabela `raw_zones` apresentou boa qualidade dos dados.

Durante o perfilamento foi constatado que:

- não existem valores nulos;
- não existem registros duplicados;
- a quantidade de registros é consistente;
- as categorias de Borough e Service Zone apresentam distribuição compatível com a documentação do conjunto de dados.

Dessa forma, a tabela foi considerada apta para utilização na camada **Staging**, sem necessidade de aplicação de regras adicionais de limpeza.