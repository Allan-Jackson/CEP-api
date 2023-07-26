require 'rails_helper'
require_relative '../../app/controllers/services/cep_service'


RSpec::Matchers.define :be_bad_request do
    match do |response|
        response.code.to_s.eql? "400"
    end
end

describe '#show' do
    
    context 'when token validation fails' do
        it 'is not present' do
            expected_response = {"erro" => "Erro de Autenticação, token ausente no header Authorization."}

            get endereco_path('05723380')

            expect(response).to be_unauthorized
            expect(JSON.parse(response.body)).to eq expected_response
        end

        it 'is expired' do
            #invalid user.id is not being considered 
            payload = {user_id: 'x', exp: (Time.now - 3600).to_i}
            tkn = JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'

            expected_response = {"erro" => "Erro de Autenticação, token expirado."}

            get endereco_path('05723380'), headers: {'Authorization': "bearer #{tkn}" }

            expect(response).to be_unauthorized
            expect(JSON.parse(response.body)).to eq expected_response
        end

        it 'is invalid' do
            #invalid user.id is not being considered 
            payload = {user_id: 'x', exp: (Time.now - 3600).to_i}
            tkn = JWT.encode payload, 'wrong secret', 'HS256'

            expected_response = {"erro" => "Erro de Autenticação, token inválido."}

            get endereco_path('05723380'), headers: {'Authorization': "bearer #{tkn}" }

            expect(response).to be_unauthorized
            expect(JSON.parse(response.body)).to eq expected_response
        end
    end

    context 'when user input is incorrect' do
        it 'CEP hasn\'t correct length' do
            #invalid user.id is not being considered 
            payload = {user_id: 'x', exp: (Time.now + 3600).to_i}
            tkn = JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'

            expected_response = {
                "reasons" => [
                    "O parâmetro CEP deve conter 8 dígitos."
                ]
            }

            get endereco_path('05723'), headers: {'Authorization': "bearer #{tkn}" }

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)).to eq expected_response
        end
        
        it 'CEP is not found' do
            #invalid user.id is not being considered 
            payload = {user_id: 'x', exp: (Time.now + 3600).to_i}
            tkn = JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'

            expected_response = {
                "reasons" => [
                    "CEP não encontrado."
                ]
            }

            get endereco_path('99999999'), headers: {'Authorization': "bearer #{tkn}" }

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)).to eq expected_response
            
        end
    end
    
    context 'when user input is OK' do
        it 'returns the address to the user' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})
            payload = {user_id: user.id, exp: (Time.now + 3600).to_i}
            tkn = JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'
            
            expected_response = {
                "cep" => "05723380",
                "logradouro" => "Rua João de Araújo Cabral",
                "bairro" => "Jardim Santo Antônio",
                "cidade" => "São Paulo",
                "uf" => "SP"
            }

            get endereco_path('05723380'), headers: {'Authorization': "bearer #{tkn}" }

            expect(response).to be_successful
            expect(JSON.parse(response.body)).to eq expected_response

        end

        it 'save the address and user in database' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})
            payload = {user_id: user.id, exp: (Time.now + 3600).to_i}
            tkn = JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'
            
            expected_response = {
                "cep" => "05723380",
                "logradouro" => "Rua João de Araújo Cabral",
                "bairro" => "Jardim Santo Antônio",
                "cidade" => "São Paulo",
                "uf" => "SP"
            }

            get endereco_path('05723380'), headers: {'Authorization': "bearer #{tkn}" }

            expect(endereco = Endereco.find_by(cep: '05723380')).not_to be_nil
            expect(endereco.usuarios).to include user
        end

        it 'get address from DB when it was already searched before' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})
            payload = {user_id: user.id, exp: (Time.now + 3600).to_i}
            tkn = JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'

            address = {cep: "05723380", uf: "SP", cidade: "São Paulo", bairro: "Jardim Santo Antônio", logradouro: "Rua João de Araújo Cabral"} 

            address = Endereco.create(address)

            get endereco_path('05723380'), headers: {'Authorization': "bearer #{tkn}" }

            expect(assigns(:endereco).id).to eql(address.id)
       
        end

        it 'get address from service if it was not searched once' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})
            payload = {user_id: user.id, exp: (Time.now + 3600).to_i}
            tkn = JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'

            # Create a double for the ExternalService instance
            service_instance = instance_double(MyCEPService)

            # Stub the external service method and set the expected response
            allow(service_instance).to receive(:buscaEndereco).with('05723380')#.and_return({ status: 'success' })

            # Replace the real ExternalService instance with the double
            allow(MyCEPService).to receive(:new).and_return(service_instance)

            # Invoke the controller action
            get endereco_path('05723380'), headers: {'Authorization': "bearer #{tkn}" }

            # Expect the external service call to have been made
            expect(service_instance).to have_received(:buscaEndereco).with('05723380').once
        end

    end

end
