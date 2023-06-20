# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


ends = [
    {cep: "05723380", uf: "SP", cidade: "São Paulo", bairro: "Jardim Santo Antônio", logradouro: "Rua João de Araújo Cabral"}, 
    {cep: "35145970", uf: "MG", cidade: "Sobrália", bairro: "Centro", logradouro: "Praça São Geraldo, 43"}       
]
users = [
    {nome: 'Joseclildo Soares', email: 'josesoares@email.com', senha: '123'},
    {nome: 'Itamar Siqueira', email: 'imatarnomar@email.com', senha: '456'}
]

#usar find_or_create_by
Usuario.create(users)
Endereco.create(ends)