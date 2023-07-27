# CEP API

## Requisitos do Sistema

Versão do Ruby: 3.1.3

## Executando no ambiente de desenvolvimento

#### Setup database

Execute `rails db:create` para criar o banco de dados, em seguida `rails db:migrate` para executar as migrações e gerar as tabelas.

#### Rodando a aplicação

##### Configurando o seeds.rb

Para conseguir utilizar a aplicação é preciso editar o arquivo `db/seeds.rb`, para adicionar um usuário para acessar as rotas.

##### Iniciando o servidor

Execute  `rails s` para iniciar o servidor. Para rodar em produção, basta usar a flag `--production`.

Então a API ficará disponível em `http://localhost:3000`.

##### Obtendo o token de acesso

Para acessar o serviço é preciso gerar um token acessando o endpoint `/auth` e informando o _email_ e _senha_ do usuário cadastrado na base.

Exemplo de chamada do token:

```shell
\$ curl -X POST -H "Content-Type: application/json" \
                -d '{"email": "{valid_email}", "senha": "{valid_password}"}' \
                http://localhost:3000/auth
```

##### Acessando a rota de endereço

Com o token em mãos, acesse `/endereco/{cep}` informando o CEP do endereço desejado na url. No header da requisição, adicione o parâmetro `Authorization: bearer {token}` informando o token obtido   

Exemplo de chamada do endereço:

```shell
curl -X GET -H "Content-Type: application/json" \
            -H "Authorization: bearer {token}" \
            http://localhost:3000/enderecos/{cep}

```

## Testes unitários

Executar `rspec` dentro da pasta raiz do projeto para rodar os testes unitários.
