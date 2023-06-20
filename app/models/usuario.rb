class Usuario < ApplicationRecord
    has_and_belongs_to_many :enderecos
    has_secure_password :senha
end
