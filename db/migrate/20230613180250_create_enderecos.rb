class CreateEnderecos < ActiveRecord::Migration[7.0]
  def change
    create_table :enderecos do |t|
      t.string :uf
      t.string :cidade
      t.string :bairro
      t.string :logradouro
      t.string :cep

      t.timestamps
    end
  end
end
