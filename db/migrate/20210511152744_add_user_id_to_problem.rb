class AddUserIdToProblem < ActiveRecord::Migration[6.1]
  def change
    add_column :problems, :user_id, :integer
  end
end
