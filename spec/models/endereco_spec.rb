require 'rails_helper'

describe 'Endereco model' do
    
    context 'when everything is alright' do
        it "saves the address to the database" do
            endereco = Endereco.new (
                {
                    cep: "05723380",
                    uf: "SP", 
                    cidade: "São Paulo", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_truthy
            expect(endereco.save).to be_truthy
        end
    end

    context 'when property is required' do

        it "is not valid without 'cep'" do
            endereco = Endereco.new (
                {
                    uf: "SP", 
                    cidade: "São Paulo", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "is not valid with empty 'nome'" do
            endereco = Endereco.new (
                {
                    cep: "",
                    uf: "SP", 
                    cidade: "São Paulo", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "is not valid without 'uf'" do
            endereco = Endereco.new (
                {
                    cep: "05723380",
                    cidade: "São Paulo", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "is not valid with empty 'uf'" do
            endereco = Endereco.new (
                {
                    cep: "05723380",
                    uf: "", 
                    cidade: "São Paulo", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "is not valid without 'cidade'" do
            endereco = Endereco.new (
                {
                    cep: "05723380",
                    uf: "SP", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "is not valid with empty 'cidade'" do
            endereco = Endereco.new (
                {
                    cep: "05723380",
                    uf: "SP", 
                    cidade: "", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "is not valid without 'bairro'" do
            endereco = Endereco.new (
                {
                    cep: "05723380",
                    uf: "SP", 
                    cidade: "São Paulo", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "is not valid with empty 'bairro'" do
            endereco = Endereco.new (
                {
                    cep: "05723380",
                    uf: "SP", 
                    cidade: "São Paulo", 
                    bairro: "", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "is not valid without 'logradouro'" do
            endereco = Endereco.new (
                {
                    cep: "05723380",
                    uf: "SP", 
                    cidade: "São Paulo", 
                    bairro: "Jardim Santo Antônio"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "is not valid with empty 'logradouro'" do
            endereco = Endereco.new (
                {
                    cep: "05723380",
                    uf: "SP", 
                    cidade: "São Paulo", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: ""
                }
            )
            expect(endereco.valid?).to be_falsy
        end
    end
       

    context 'when property is invalid' do

        it "has not the correct size for 'cep'" do
            endereco = Endereco.new (
                {
                    cep: "0572338",
                    uf: "SP", 
                    cidade: "São Paulo", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "has not the correct size for 'uf'" do
            endereco = Endereco.new (
                {
                    cep: "05723380",
                    uf: "SPA", 
                    cidade: "São Paulo", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

        it "has not a unique 'cep'" do
            Endereco.create({
                cep: "05723380",
                uf: "SP", 
                cidade: "São Paulo", 
                bairro: "Jardim Santo Antônio", 
                logradouro: "Rua João de Araújo Cabral"
            })

            endereco = Endereco.new (
                {
                    cep: "05723380",
                    uf: "SP", 
                    cidade: "São Paulo", 
                    bairro: "Jardim Santo Antônio", 
                    logradouro: "Rua João de Araújo Cabral"
                }
            )
            expect(endereco.valid?).to be_falsy
        end

    end

end