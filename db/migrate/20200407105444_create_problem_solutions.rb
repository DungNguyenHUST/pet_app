class CreateProblemSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :problem_solutions do |t|
      t.string :user_name
      t.string :title
      t.text :content
      t.integer :vote

      t.timestamps
    end
  end
end
