class AddIndexToEnderecoTable < ActiveRecord::Migration[7.0]
  def change
    add_index :enderecos, :cep, unique: true
  end
end
