class AddPlanToEmployer < ActiveRecord::Migration[6.1]
  def change
    add_column :employers, :plan, :string
  end
end
