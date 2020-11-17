class CreateScheduleItems < ActiveRecord::Migration[6.0]
  def change
    create_table :schedule_items do |t|
      t.references :user,  type: :string, null: false
      t.integer :status, null: false
      t.text :content, null: false

      t.timestamps
    end
    add_foreign_key :schedule_items, :users, column: :user_id , primary_key: :line_id
  end
end
