class InvalidCepError < StandardError
    def initialize(message = "CEP inválido")
        super(message)
    end
end