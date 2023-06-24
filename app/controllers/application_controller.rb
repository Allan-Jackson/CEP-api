class ApplicationController < ActionController::API
    before_action :token_validation


    def token_validation
        # obter o token do header
        # verificar se o token foi devidamente decodificado com o secret
        if request.headers['Authorization'].present?
            # o token vem na string 'Bearer {token}'
            decoded_token = decode_jwt request.headers['Authorization'].split(' ').last
            # valida se o token foi decodificado certinho (tamanho maior que 1) ou não (igual a 1)
            if decoded_token.size > 1
                @user_id = decoded_token.first['user_id']
            else
                if decoded_token.first[:expired]
                    render json: {erro: 'Erro de Autenticação, token expirado.'}, status: :unauthorized         
                else
                    render json: {erro: 'Erro de Autenticação, token inválido.'}, status: :unauthorized
                end
            end
        else
            render json: {erro: 'Erro de Autenticação, token ausente no header Authorization.'}, status: :unauthorized
        end
    end
    
  protected
    def validate_schema (schema)
        begin
            JSON::Validator.validate!(schema, request.raw_post())
        rescue JSON::Schema::ValidationError => e
            @res = {
                body: {erro: e.message},
                status: :bad_request
            }
            false
        end
    end

  private
    def encode_jwt(payload = {})
        JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'
    end

    def decode_jwt(token)
        begin
            JWT.decode token, Rails.application.credentials.dig(:auth, :jwt_secret), true, { algorithm: 'HS256' }
        rescue JWT::ExpiredSignature
            [{expired: true}]
        rescue
            [{invalid: true}]
        end
    end
end
