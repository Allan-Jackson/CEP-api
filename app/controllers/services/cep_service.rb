require_relative 'service'
require 'uri'

class MyCEPService < MyService
    @uri

    def initialize()
        @uri = URI::HTTP.build(host: 'cep.la')
    end

    def buscaEndereco(cep)
        get @uri + cep, {'Accept' =>'application/json'}
    end
end