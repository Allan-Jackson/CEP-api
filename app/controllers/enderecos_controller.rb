require_relative 'cep_service'
require 'json'

class EnderecosController < ApplicationController
  before_action :set_endereco, only: %i[ show update destroy ]

  # GET /enderecos
  def index
    @enderecos = Endereco.all
    render json: @enderecos
  end

  # GET /enderecos/1
  def show
    render json: @endereco
  end

  # # POST /enderecos
  # def create
  #   @endereco = Endereco.new(endereco_params)

  #   if @endereco.save
  #     render json: @endereco, status: :created, location: @endereco
  #   else
  #     render json: @endereco.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /enderecos/1
  # def update
  #   if @endereco.update(endereco_params)
  #     render json: @endereco
  #   else
  #     render json: @endereco.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /enderecos/1
  # def destroy
  #   @endereco.destroy
  # end

  #from this point forward, the methods are all private
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_endereco      
      #executes when the expression evaluates to false
      unless (endereco = Endereco.find_by(cep: params[:cep])).nil?
        @endereco = endereco
      else
        @endereco = MyCEPService.new.buscaEndereco(params[:cep])
        salvaEndereco(@endereco)
      end
      return @endereco
    end

    # Only allow a list of trusted parameters through.
    def endereco_params
      params.require(:endereco).permit(:uf, :cidade, :bairro, :logradouro)
    end

    def salvaEndereco(endereco)
      endereco = JSON.parse(endereco)
      Endereco.create(endereco)
    end
end
