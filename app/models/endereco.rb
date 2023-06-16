class Endereco < ApplicationRecord
    has_and_belongs_to_many :usuarios
end
