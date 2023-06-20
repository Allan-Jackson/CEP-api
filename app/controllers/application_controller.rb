class ApplicationController < ActionController::API
    before_action :token_validation


    def token_validation
        # obter o token do header
        # verificar se o token foi devidamente decodificado com o secret
        if request.headers['Authorization'].present?
            begin
                # o token vem na string 'Bearer {token}'
                decoded_token = decode_jwt request.headers['Authorization'].split(' ').last
                @user_id = decoded_token.first['user_id']
            rescue
                render json: {erro: 'Erro de Autenticação, token inválido.'}, status: :unauthorized
            end
        else
            render json: {erro: 'Erro de Autenticação, token ausente no header Authorization.'}, status: :unauthorized
        end
    end
    
  private
    def encode_jwt(payload = {})
        JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'
    end

    def decode_jwt(token)
        JWT.decode token, Rails.application.credentials.dig(:auth, :jwt_secret), true, { algorithm: 'HS256' }
    end
end
