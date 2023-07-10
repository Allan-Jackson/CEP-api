require_relative 'utils/logger.rb'

class ApplicationController < ActionController::API
    include MyLogger

    before_action :log_setup, :token_validation


    def log_setup
        # $LOG = Logger.new('log/application.log', 'daily')
        # $LOG.level = Logger::DEBUG
    end

    def token_validation
        log_info "started resource access validation"
        # obter o token do header
        # verificar se o token foi devidamente decodificado com o secret
        log_debug "authorization header present? #{request.headers['Authorization'].present?}"
        if request.headers['Authorization'].present?
            # o token vem na string 'Bearer {token}'
            decoded_token = decode_jwt request.headers['Authorization'].split(' ').last
            log_debug "decoded token: #{decoded_token.inspect}"
            # valida se o token foi decodificado certinho (tamanho maior que 1) ou não (igual a 1)
            if decoded_token.size > 1
                log_info "resource access was successfully granted"
                @user_id = decoded_token.first['user_id']
            else
                if decoded_token.first[:expired]
                    render json: {erro: 'Erro de Autenticação, token expirado.'}, status: :unauthorized         
                else
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
        log_debug "encoding JWT"
        JWT.encode payload, Rails.application.credentials.dig(:auth, :jwt_secret), 'HS256'
    end

    def decode_jwt(token)
        begin
            log_debug "decoding JWT"
            JWT.decode token, Rails.application.credentials.dig(:auth, :jwt_secret), true, { algorithm: 'HS256' }
        rescue JWT::ExpiredSignature
            log_error "JWT expired"
            [{expired: true}]
        rescue
            log_error "JWT invalid"
            [{invalid: true}]
        end
    end
end
