class AddPlanToEmployer < ActiveRecord::Migration[6.1]
  def change
    add_column :employers, :plan, :string
    add_column :employers, :start_plan, :datetime
    add_column :employers, :end_plan, :datetime
  end
end
