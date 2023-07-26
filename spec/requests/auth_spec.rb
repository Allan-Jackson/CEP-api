require 'rails_helper'

describe '#create_token' do

    context 'when user input is OK' do
        it 'returns the access token' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})
            payload = {user_id: user.id, exp: (Time.now + 3600).to_i}
            tkn = JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'
            

            expected_response = {
                "token" => tkn
            }

            post auth_path('05723380', {
                "email": "teste.usuario@email.com",
                "senha": "C4lr0ç!N8Y"
            })

            expect(response).to be_successful
            expect(JSON.parse(response.body)).to eq expected_response
        end
    end

    context 'when user email validation fails' do

        it 'has no \'email\' field on payload' do
            expected_response = {
                "reasons" => [
                    {
                        "email" => "email inválido.",
                        "errors" => [
                            "O parâmetro 'email' deve ser informado."
                        ]
                    }
                ]
            }

            post auth_path('05723380', {
                "senha": "C4lr0ç!N8Y"
            })

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)).to eq expected_response
        end

        it 'has invalid email' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})          

            expected_response = {
                "reasons" => [
                    {
                        "email" => "email inválido.",
                        "errors" => [
                            "Formato inválido para o campo 'email'."
                        ]
                    }
                ]
            }

            post auth_path('05723380', {
                "email": "teste.invalid.com",
                "senha": "C4lr0ç!N8Y"
            })

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)).to eq expected_response
        end
    end

    context 'when user password validation fails' do
        
        it 'has no \'senha\' field on payload' do
            expected_response = {
                "reasons" => [
                    {
                        "senha" => "senha inválida.",
                        "errors" => [
                            "O parâmetro 'senha' deve ser informado."
                        ]
                    }
                ]
            }

            post auth_path('05723380', {
                "email": "teste.usuario@email.com"
            })

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)).to eq expected_response
        end

        it 'has not reached the minimum size' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})          

            expected_msg = "A senha deve ter pelo menos 8 caracteres."

            post auth_path('05723380', {
                "email": "teste.usuario@email.com",
                "senha": "C4lr0ç"
            })

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)["reasons"].first["errors"]).to include expected_msg
        end

        it 'has exceed the maximum size' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})          

            expected_msg = "A senha não deve exceder 60 caracteres."

            post auth_path('05723380', {
                "email": "teste.usuario@email.com",
                "senha": "4lr0çC4lr0çC4lr0çC4lr0çC$4lr0çC4lr0çC4lr0çC4lr0çC4lr0çC4lr0çC4lr"
            })

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)["reasons"].first["errors"]).to include expected_msg
        end

        it 'has incorrect number of special characters' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})          

            expected_response = {
                "reasons" => [
                    {
                        "senha" =>"senha inválida.",
                        "errors" => [
                            "A senha deve conter pelo menos 1 caracteres especiais."
                        ]
                    }
                ]
            }

            post auth_path('05723380', {
                "email": "teste.usuario@email.com",
                "senha": "C4lr0çN8Y"
            })

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)).to eq expected_response
            
        end

        it 'has incorrect number of uppercase characters' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})          

            expected_response = {
                "reasons" => [
                    {
                        "senha" =>"senha inválida.",
                        "errors" => [
                            "A senha deve conter pelo menos 1 letra(s) maiúscula(s)."
                        ]
                    }
                ]
            }

            post auth_path('05723380', {
                "email": "teste.usuario@email.com",
                "senha": "4lr0ç!8d"
            })

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)).to eq expected_response
        end

        it 'has incorrect number of lowercase characters' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})          

            expected_response = {
                "reasons" => [
                    {
                        "senha" =>"senha inválida.",
                        "errors" => [
                            "A senha deve conter pelo menos 1 letra(s) minúscula(s)."
                        ]
                    }
                ]
            }

            post auth_path('05723380', {
                "email": "teste.usuario@email.com",
                "senha": "41R0Ç!8D"
            })

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)).to eq expected_response
        end

        it 'has incorrect number of numeric characters' do
            user = Usuario.create({nome: 'Usuario Teste', email: 'teste.usuario@email.com', senha: 'C4lr0ç!N8Y'})          

            expected_response = {
                "reasons" => [
                    {
                        "senha" =>"senha inválida.",
                        "errors" => [
                            "A senha deve conter pelo menos 2 números."
                        ]
                    }
                ]
            }

            post auth_path('05723380', {
                "email": "teste.usuario@email.com",
                "senha": "Clr0ç!NY"
            })

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)).to eq expected_response
        end
    end
end