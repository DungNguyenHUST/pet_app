class AddCoverLetterToCompanyApplyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_apply_jobs, :cover_letter, :text
  end
end
