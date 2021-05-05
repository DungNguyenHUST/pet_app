class AddApplySiteToCompanyJob < ActiveRecord::Migration[6.1]
  def change
    add_column :company_jobs, :apply_site, :string
  end
end
