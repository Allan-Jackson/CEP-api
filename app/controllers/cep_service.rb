require_relative 'service'
require 'uri'

class MyCEPService < MyService
    @uri

    def initialize()
        # @uri = URI('http://cep.la') 
        @uri = URI::HTTP.build(host: 'cep.la')
        # @uri = 'politica'
    end

    def cassete
        puts @uri.hostname
    end

    def buscaEndereco(cep)
        get @uri + cep, {'Accept' =>'application/json'}
    end
end