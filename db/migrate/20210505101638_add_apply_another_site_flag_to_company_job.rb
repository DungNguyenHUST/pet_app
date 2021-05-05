class AddApplyAnotherSiteFlagToCompanyJob < ActiveRecord::Migration[6.1]
  def change
    add_column :company_jobs, :apply_another_site_flag, :boolean, :default => false
  end
end
