class AddLanguageToCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :company_jobs, :language, :string
  end
end
