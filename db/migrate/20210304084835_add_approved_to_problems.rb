class AddApprovedToProblems < ActiveRecord::Migration[6.0]
  def change
    add_column :problems, :approved, :boolean, default: false
  end
end
