class Usuario < ApplicationRecord
    has_and_belongs_to_many :enderecos
    has_secure_password :senha
    validates :nome, :email, :senha_digest, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :senha, length: {minimum: 8, maximum: 30}

    #TODO: custom validation para a senha
end
