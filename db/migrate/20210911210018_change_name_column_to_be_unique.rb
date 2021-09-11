class ChangeNameColumnToBeUnique < ActiveRecord::Migration
  def change
    change_column :responders, :name, :string, unique: true
  end
end
