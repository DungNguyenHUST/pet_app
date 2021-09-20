class AddPublicToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :public, :boolean, :default => true
    add_column :users, :finding_job, :boolean, :default => true
  end
end
