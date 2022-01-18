class AddCostToEmployer < ActiveRecord::Migration[6.1]
  def change
    add_column :employers, :limit_cost, :bigint, default: 0
    add_column :employers, :remain_cost, :bigint, default: 0
    add_column :employers, :promotion_cost, :bigint, default: 0
    add_column :employers, :use_cost_seq, :integer, default: 0
    add_column :employers, :stop_cost, :boolean, default: false
  end
end
