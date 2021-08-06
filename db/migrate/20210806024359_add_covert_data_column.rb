class AddCovertDataColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :name_converted, :string
    add_column :companies, :location_converted, :string
    add_column :company_jobs, :title_converted, :string
    add_column :company_jobs, :location_converted, :string
    add_column :problems, :title_converted, :string
    add_column :posts, :title_converted, :string
  end
end
