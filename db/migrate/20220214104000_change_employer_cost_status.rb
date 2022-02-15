class ChangeEmployerCostStatus < ActiveRecord::Migration[6.1]
  def change
    remove_column :employers, :stop_cost
    add_column :employers, :cost_status, :integer, default: 0
  end
end
