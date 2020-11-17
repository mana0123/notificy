class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: false do |t|
      t.string :line_id, null: false, primary_key: true
      t.string :user_type, null: false
      t.integer :status, null: false
      t.string :access_token_digest

      t.timestamps
    end
  end
end
