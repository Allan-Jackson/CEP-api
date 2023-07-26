require_relative 'utils/logger.rb'

class ApplicationController < ActionController::API
    include MyLogger

    before_action :token_validation

    protected
    def token_validation
        log_info "started resource access validation"
        # obter o token do header
        # verificar se o token foi devidamente decodificado com o secret
        log_debug "authorization header present? #{request.headers['Authorization'].present?}"
        if request.headers['Authorization'].present?
            log_debug "decoding JWT..."
            # o token vem na string 'Bearer {token}'
            decoded_token = decode_jwt request.headers['Authorization'].split(' ').last
            log_debug "decoded token: #{decoded_token.inspect}"
            # valida se o token foi decodificado certinho (tamanho maior que 1) ou não (igual a 1)
            if decoded_token.size > 1
                log_info "resource access was successfully granted"
                @user_id = decoded_token.first['user_id']
            else #TODO: verificar os logs na situação do token expirado
                if decoded_token.first[:expired]
                    log_error "JWT expired"
                    render json: {erro: 'Erro de Autenticação, token expirado.'}, status: :unauthorized         
                else
                    log_error "JWT invalid"
                    render json: {erro: 'Erro de Autenticação, token inválido.'}, status: :unauthorized
                end
            end
        else
            log_error "authorization header is missing"
            render json: {erro: 'Erro de Autenticação, token ausente no header Authorization.'}, status: :unauthorized
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
