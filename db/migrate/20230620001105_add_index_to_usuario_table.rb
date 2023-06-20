class AddIndexToUsuarioTable < ActiveRecord::Migration[7.0]
  def change
    add_index :usuarios, :email, unique: true
  end
end
