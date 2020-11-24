class CreateProblemVoteSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :problem_vote_solutions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :problem_solution, null: false, foreign_key: true

      t.timestamps
    end
  end
end
