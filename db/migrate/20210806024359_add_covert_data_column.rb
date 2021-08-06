class AddCovertDataColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :name_coverted, :string
    add_column :companies, :location_coverted, :string
    add_column :company_jobs, :title_coverted, :string
    add_column :company_jobs, :location_coverted, :string
    add_column :problems, :title_coverted, :string
    add_column :posts, :title_coverted, :string
  end
end
