class AddApprovedToProblems < ActiveRecord::Migration[6.1]
  def change
    add_column :problems, :approved, :boolean, default: false
  end
end
