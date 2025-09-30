# Challenge Cloud Sprint 3

## Arquitetura

A aplicação utiliza uma arquitetura baseada em containers no Azure Container Instances (ACI), com os seguintes componentes:

![Diagrama da Arquitetura](https://github.com/user-attachments/assets/a4317601-ab97-45f9-8c07-250f92d3ec3e)

- **API .NET**: Container com a aplicação REST API desenvolvida em .NET
- **MySQL**: Container com o banco de dados MySQL

## Como Executar

### 1. Clone o Repositório

```bash
git clone https://github.com/guiakiraa/challenge-cloud-sprint3.git
cd challenge-cloud-sprint3
```

### 2. Execute o Script de Deploy

```bash
chmod +x ./script.sh
./script.sh
```

## Acessando o MySQL

### Conectar ao Banco de Dados

1. Obtenha o IP do ACI do MySQL
2. Execute o comando abaixo:

```bash
docker run -it --rm mysql:8.0 mysql \
  -h <IP_DO_MYSQL> \
  -P 3306 \
  -u root \
  -p
```

3. Quando solicitado, insira a senha: `MinhaSenhaSegura`

### Comandos Úteis

```sql
show databases;
use tria_app;
show tables;
```

## Testando a API .NET

### Endpoint Base

Obtenha o IP do ACI do .NET e acesse:

```
http://<IP_DO_DOTNET>:8080/api/Endereco
```

### Payloads de Teste

#### POST - Criar Endereço 1

```json
{
  "logradouro": "Avenida Paulista",
  "cidade": "São Paulo",
  "estado": "SP",
  "numero": "250",
  "complemento": "bloco A",
  "cep": "04260000"
}
```

#### POST - Criar Endereço 2

```json
{
  "logradouro": "Rua Piratininga",
  "cidade": "Osasco",
  "estado": "SP",
  "numero": "20",
  "complemento": "Bloco a",
  "cep": "12345678"
}
```

#### PUT - Atualizar Endereço (ID 1)

```json
{
  "id": 1,
  "logradouro": "Avenida Paulista",
  "cidade": "São Paulo",
  "estado": "SP",
  "numero": "1000",
  "complemento": "bloco A",
  "cep": "04260000"
}
```

#### PUT - Atualizar Endereço (ID 2)

```json
{
  "id": 2,
  "logradouro": "Rua Piratininga",
  "cidade": "Osasco",
  "estado": "SP",
  "numero": "20",
  "complemento": "Bloco B",
  "cep": "12345678"
}
```
