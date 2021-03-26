class AddSlugToProblemReplySolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :problem_reply_solutions, :slug, :string
    add_index :problem_reply_solutions, :slug, unique: true
  end
end
