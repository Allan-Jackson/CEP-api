require "json-schema"

class AuthController < ApplicationController
    skip_before_action :token_validation

    # POST /auth
    def create_token
        
        errors = validate_payload (params)

        unless errors.empty?
            render json: {reasons: errors}, status: :bad_request
            return;
        end
        
        # busca usuário no banco e bate a senha
        if user = Usuario.find_by(email: params[:email])&.authenticate_senha(params[:senha])
            render json: {token: encode_jwt({user_id: user.id, exp: (Time.now + 3600).to_i})}, status: :ok
        else 
            render json: {erro: 'E-mail e/ou senha do usuário incorreto(s).'}, status: :bad_request
        end
        
    rescue
        render json: {erro: 'Houve algum erro com o serviço. Por favor, tente novamente mais tarde...'}, status: 500
    end

    # TODO: obter regex para validar e-mail
    def validate_email(email)
        return [1] if email.nil?
        []
    end

    def validate_senha(password)
        errors = []
    
        min_length = 8
        max_length = 60
        min_upper = 1
        min_lower = 1
        min_special = 1
        min_number = 2
    
    
        special_chars = "!@#$%^&*()_-+=<>?/\\|{}[]~"
        count = {
            upper: 0,
            lower: 0,
            special: 0,
            number: 0
        }
        
        if password.nil?
            return  errors << "O parâmetro senha deve ser informado."
        elsif password.length < min_length
            errors << "A senha deve ter pelo menos #{min_length} caracteres."
        elsif password.length > max_length
            errors << "A senha não deve exceder #{max_length} caracteres."
        end
    
    
        password.each_char do |char|
            count[:lower] += 1 if char =~ /[a-z]/
            count[:upper] += 1 if char =~ /[A-Z]/
            count[:number] += 1 if char =~ /[0-9]/
            count[:special] += 1 if special_chars.include?(char)
        end
    
        if count[:lower] < min_lower
            errors << "A senha deve conter pelo menos #{min_lower} letra(s) minúscula(s)."
        end

        if count[:upper] < min_upper
            errors << "A senha deve conter pelo menos #{min_upper} letra(s) maiúscula(s)."
        end

        if count[:number] < min_number
            errors << "A senha deve conter pelo menos #{min_number} números."
        end
    
        if count[:special] < min_special
            errors << "A senha deve conter pelo menos #{min_upper} caracteres especiais."
        end

        return errors;
    end

    def validate_payload (payload)
        validations = []
        
        unless (errors=validate_email(payload[:email])).empty?
            validations << {email: 'email inválido.', errors:}
        end
        unless (errors=validate_senha(payload[:senha])).empty?
            validations << {senha: 'senha inválida.', errors:}
        end
        
        validations
    end

end