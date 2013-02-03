class AddNameAttributeToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :state, :string
  end
end