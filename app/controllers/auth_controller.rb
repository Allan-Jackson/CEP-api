class AuthController < ApplicationController
    skip_before_action :token_validation

    def create_token
        # recebe os parâmetros email e senha do usuário
        user = Usuario.find_by(email: params[:email])&.authenticate_senha(params[:senha])

        if user
            render json: {token: encode_jwt({user_id: user.id})}, status: :ok
        else
            render json: {erro: 'E-mail ou senha incorretos.'}, status: :bad_request
        end

    end
end
