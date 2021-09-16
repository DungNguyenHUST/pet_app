class ResetIdOfCompanyJobTable < ActiveRecord::Migration[6.1]
  def change
    execute "SELECT setval('company_jobs_id_seq', 80000)"
  end
end
