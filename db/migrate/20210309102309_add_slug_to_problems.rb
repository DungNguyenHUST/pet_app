class AddSlugToProblems < ActiveRecord::Migration[6.1]
  def change
    add_column :problems, :slug, :string
    add_index :problems, :slug, unique: true
  end
end
