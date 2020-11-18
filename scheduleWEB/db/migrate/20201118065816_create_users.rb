class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.integer :user_type
      t.integer :status
      t.string :access_digest

      t.timestamps
    end
    add_index :users, :name, unique: true
  end
end
