class AddAccessedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :access_at, :datetime
  end
end
