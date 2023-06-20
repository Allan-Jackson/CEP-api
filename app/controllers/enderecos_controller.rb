require_relative 'services/cep_service'
require 'json'

class EnderecosController < ApplicationController
  before_action :set_endereco, only: %i[ show update destroy ]

  # GET /enderecos/1
  def show
    associa_usuario_endereco(@user_id, @endereco)
    render json: @endereco
  end

  private
    def set_endereco      
      unless (endereco = Endereco.find_by(cep: params[:cep])).nil?
        @endereco = endereco
      else
        @endereco = salva_endereco(MyCEPService.new.buscaEndereco(params[:cep]))
      end
    end

    # Only allow a list of trusted parameters through.
    def endereco_params
      params.require(:endereco).permit(:uf, :cidade, :bairro, :logradouro)
    end

    def salva_endereco(endereco)
      endereco = JSON.parse(endereco)
      Endereco.create(endereco)
    end

    def associa_usuario_endereco(id_usuario, endereco)
      unless endereco.usuarios.include? Usuario.find(id_usuario)
        endereco.usuarios << Usuario.find(id_usuario)
        endereco.save
      end
    end
end
