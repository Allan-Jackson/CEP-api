class Endereco < ApplicationRecord
    has_and_belongs_to_many :usuarios
    validates :cep, :logradouro, :bairro, :cidade, :uf, presence: true
    validates :cep, length: {is: 8}
    validates :uf, length: {is: 2}
    validates :cep, uniqueness: true
end
