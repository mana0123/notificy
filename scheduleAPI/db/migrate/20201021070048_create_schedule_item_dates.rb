class CreateScheduleItemDates < ActiveRecord::Migration[6.0]
  def change
    create_table :schedule_item_dates do |t|
      t.references :schedule_item, foreign_key: true, null: false
      t.integer :year
      t.integer :month
      t.integer :week
      t.integer :day
      t.integer :hour

      t.timestamps
    end

    add_index :schedule_item_dates, :year
    add_index :schedule_item_dates, :month
    add_index :schedule_item_dates, :week
    add_index :schedule_item_dates, :day
    add_index :schedule_item_dates, :hour
  end
end
