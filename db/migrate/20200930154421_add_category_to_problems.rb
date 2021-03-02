class AddCategoryToProblems < ActiveRecord::Migration[6.0]
  def change
    add_column :problems, :category, :string
  end
end
