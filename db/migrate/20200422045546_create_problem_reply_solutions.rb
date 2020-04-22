class CreateProblemReplySolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :problem_reply_solutions do |t|
      t.string :user_name
      t.string :reply_content
      t.integer :problem_solution_id

      t.timestamps
    end
  end
end
