class CreateUsuarios < ActiveRecord::Migration[7.0]
  def change
    create_table :usuarios do |t|
      t.string :nome
      t.string :email
      t.string :senha_digest

      t.timestamps
    end
  end
end
