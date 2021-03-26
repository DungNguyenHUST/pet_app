class AddSlugToProblemSolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :problem_solutions, :slug, :string
    add_index :problem_solutions, :slug, unique: true
  end
end
