class ChangeColToJob < ActiveRecord::Migration[6.1]
  def change
    remove_column :company_jobs, :sponsor
    remove_column :company_jobs, :urgent
    add_column :company_jobs, :sponsor, :integer, :default => false
    add_column :company_jobs, :urgent, :integer, :default => false
  end
end
