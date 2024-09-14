class CreateProfileFields < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_fields do |t|
      t.references :team, null: false, foreign_key: true
      t.string :field

      t.timestamps
    end
  end
end
