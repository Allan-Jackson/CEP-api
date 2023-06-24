require_relative 'services/cep_service'
require 'json'

class EnderecosController < ApplicationController
  before_action :set_endereco, only: %i[ show update destroy ]
  rescue_from InvalidCepError, with: :handle_invalid_cep

  # GET /enderecos/1
  def show
    unless @validation_errors.empty?
      render json: {reasons: @validation_errors}, status: :bad_request      
      return;
    end
    associa_usuario_endereco(@user_id, @endereco)
    
    # pega os atributos da tabela num hash
    attrs = @endereco.attributes
    attrs.symbolize_keys => {cep:, logradouro:, bairro:, cidade:, uf:}
    
    resposta = {
      cep:,
      logradouro:,
      bairro:,
      cidade:,
      uf:
    }
    
    render json: resposta
  rescue
    render json: {erro: 'Houve algum erro com o serviço. Por favor, tente novamente mais tarde...'}, status: 500
  end

  private
    def set_endereco   
      validate_cep(params[:cep])

      unless (endereco = Endereco.find_by(cep: params[:cep])).nil?
        puts 'OLHA:'
        puts endereco
        @endereco = endereco
      else
        @endereco = salva_endereco(MyCEPService.new.buscaEndereco(params[:cep]))
      end
      rescue
        raise
    end

    # Only allow a list of trusted parameters through.
    def endereco_params
      params.require(:endereco).permit(:uf, :cidade, :bairro, :logradouro)
    end

    def salva_endereco(endereco)
      end_columns = [:uf, :cep, :bairro, :cidade, :logradouro]
      endereco = JSON.parse(endereco).select { |key, _| end_columns.include?(key) }
      Endereco.create(endereco)
    end

    def associa_usuario_endereco(id_usuario, endereco)
      unless endereco.usuarios.include? Usuario.find(id_usuario)
        endereco.usuarios << Usuario.find(id_usuario)
        endereco.save
      end
    end

    #validations
    def validate_cep (cep)
      @validation_errors = []
      if cep.nil?
        @validation_errors << "O parâmetro CEP não pode estar ausente."
      elsif cep.size != 8
        @validation_errors << "O parâmetro CEP deve conter 8 dígitos."
      end
      
      raise InvalidCepError
    end

    def handle_invalid_cep
      render json: {reasons: @validation_errors}, status: :bad_request
    end
end

class InvalidCepError < StandardError
  def initialize(message = "CEP inválido")
    super(message)
  end
end
