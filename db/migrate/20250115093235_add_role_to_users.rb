class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :user_type, :string, default: 'user'
  end
end
