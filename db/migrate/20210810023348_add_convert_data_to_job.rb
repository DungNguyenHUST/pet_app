class AddConvertDataToJob < ActiveRecord::Migration[6.1]
  def change
    add_column :company_jobs, :salary_min, :integer
    add_column :company_jobs, :salary_max, :integer
    add_column :company_jobs, :category_converted, :string
    add_column :company_jobs, :company_name, :string
    add_column :company_jobs, :company_name_converted, :string
    add_column :company_jobs, :level_converted, :string
    add_column :company_jobs, :skill_converted, :string
    add_column :company_jobs, :typical_converted, :string
    add_column :company_jobs, :experience, :string
    add_column :company_jobs, :experience_converted, :string
    add_column :company_jobs, :policy, :string
  end
end