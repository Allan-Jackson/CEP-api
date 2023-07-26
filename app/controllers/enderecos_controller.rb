require_relative 'services/cep_service'
require_relative 'errors/invalid_cep_error'
require 'json'

class EnderecosController < ApplicationController
  
  attr_reader :validation_errors
  @resposta

  def initialize
    @validation_errors = []
  end

  # GET /enderecos/1
  def show
    # render json: 'OK', status: 200
    # return
    log_info "endpoint '/enderecos/{cep}' accessed"
    log_info "param CEP: #{params[:cep].inspect}"

    set_endereco

    # unless @validation_errors.empty?
    #   log_error "invalid user payload. errors: #{errors.inspect}"
    #   render json: {reasons: @validation_errors}, status: :bad_request      
    #   return;
    # end
    associa_usuario_endereco(@user_id, @endereco)
    
    # pega os atributos da tabela num hash
    attrs = @endereco.attributes
    attrs.symbolize_keys => {cep:, logradouro:, bairro:, cidade:, uf:}
    
    @resposta = {
      cep:,
      logradouro:,
      bairro:,
      cidade:,
      uf:
    }
    
    render json: @resposta and return

  rescue InvalidCepError
    log_error "invalid CEP. errors: #{@validation_errors.inspect}"
    handle_invalid_cep
  rescue StandardError => e
    log_fatal [e.message, *e.backtrace].join($/)
    handle_error
  ensure
    log_info "response: status => #{response.status} #{}, payload => #{@resposta.to_json}"
  end

  private
    def set_endereco   
      check_cep_size(params[:cep])

      unless (endereco = Endereco.find_by(cep: params[:cep])).nil?
        log_debug "getting address from database: #{endereco.inspect}"
        @endereco = endereco
      else
        endereco = JSON.parse(MyCEPService.new.buscaEndereco(params[:cep]))
        
        
        check_endereco_exists(endereco)

        log_debug "address found from API: #{endereco.inspect}"
        @endereco = salva_endereco(endereco)
      end
    end

    # Only allow a list of trusted parameters through.
    def endereco_params
      params.require(:endereco).permit(:uf, :cidade, :bairro, :logradouro)
    end

    def salva_endereco(endereco)
      end_columns = [:uf, :cep, :bairro, :cidade, :logradouro]
      endereco = endereco.symbolize_keys.select { |key, _| end_columns.include?(key) }
      log_debug "address with selected fields to save to database: #{endereco.inspect}"
      Endereco.create(endereco)
    end

    def associa_usuario_endereco(id_usuario, endereco)
      unless endereco.usuarios.include? user = Usuario.find(id_usuario)
        log_debug "associating user: {userId: #{user.id}, username: #{user.nome}, email: #{user.email}} to address in database"
        endereco.usuarios << user
        endereco.save
      end
    end

    #validations
    def check_cep_size (cep)
      log_debug "validating cep size..."
      if cep.size != 8
        @validation_errors << "O parâmetro CEP deve conter 8 dígitos."
        raise InvalidCepError and return
      end
    end

    def check_endereco_exists (endereco)
      log_debug "validating cep is valid..."
      if endereco.empty? 
        @validation_errors << "CEP não encontrado."
        raise InvalidCepError
      end
    end

    def handle_invalid_cep
      render json: @resposta = {reasons: @validation_errors}, status: :bad_request and return
    end

    def handle_error
      render json: @resposta = {erro: 'Houve algum erro com o serviço. Por favor, tente novamente mais tarde...'}, status: 500 and return
    end
end


