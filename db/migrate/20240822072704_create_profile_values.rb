class CreateProfileValues < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_values do |t|
      t.references :profile_field, null: false, foreign_key: true
      t.string :value
      t.references :member, null: false, foreign_key: true
      t.timestamps
    end
  end
end
