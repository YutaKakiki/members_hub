class RemoveBirthFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :birth
  end
end
