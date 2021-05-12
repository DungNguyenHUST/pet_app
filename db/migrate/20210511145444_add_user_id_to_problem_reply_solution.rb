class AddUserIdToProblemReplySolution < ActiveRecord::Migration[6.1]
  def change
    add_column :problem_reply_solutions, :user_id, :integer
  end
end
