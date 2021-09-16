class RemoveClothingPreferenceFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :clothing_preference, :string
  end
end
