class AddUserIdToProblemSolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :problem_solutions, :user_id, :integer
  end
end
