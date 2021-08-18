class CreateProblemReactSolutions < ActiveRecord::Migration[6.1]
  def change
    create_table :problem_react_solutions do |t|
      t.integer "user_id"
      t.integer "react_type", :default => -1
      t.references :problem_solution, null: false, foreign_key: true

      t.timestamps
    end
  end
end
