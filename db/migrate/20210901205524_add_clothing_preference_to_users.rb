class AddClothingPreferenceToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :clothing_preference, :string
    add_index :users, :clothing_preference
  end
end
