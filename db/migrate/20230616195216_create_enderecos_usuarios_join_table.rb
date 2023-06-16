class CreateEnderecosUsuariosJoinTable < ActiveRecord::Migration[7.0]
  def change
    #create the associating table
    create_join_table :enderecos, :usuarios
  end
end