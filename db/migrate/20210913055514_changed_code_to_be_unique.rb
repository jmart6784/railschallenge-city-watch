class ChangedCodeToBeUnique < ActiveRecord::Migration
  def change
    change_column :emergencies, :code, :string, unique: true
  end
end
