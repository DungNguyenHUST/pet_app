class CreateCompanyApplyJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :company_apply_jobs do |t|
      t.text :name
      t.text :email
      t.integer :company_job_id

      t.timestamps
    end
  end
end
