class CreateAdminUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_users do |t|
      t.string :name
      t.string :password_digest
      t.timestamps
    end
    add_index :admin_users, :name, unique: true
  end
end
