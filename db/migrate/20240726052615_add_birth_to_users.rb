class AddBirthToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users,:birth,:datetime
  end
end
