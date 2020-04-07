class AddProblemIdToProblemSolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :problem_solutions, :problem_id, :integer
  end
end
