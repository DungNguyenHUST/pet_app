class AddCoverVitateToCompanyApplyJobs < ActiveRecord::Migration[6.1]
  def change
    add_column :company_apply_jobs, :cover_vitate, :string
  end
end
