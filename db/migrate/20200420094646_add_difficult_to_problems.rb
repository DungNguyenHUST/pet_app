class AddDifficultToProblems < ActiveRecord::Migration[6.0]
  def change
    add_column :problems, :difficult, :string
  end
end
