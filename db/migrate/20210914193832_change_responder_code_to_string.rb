class ChangeResponderCodeToString < ActiveRecord::Migration
  def change
    change_column :responders, :emergency_code, :string
  end
end
