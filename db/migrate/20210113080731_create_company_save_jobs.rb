class CreateCompanySaveJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :company_save_jobs do |t|

      t.timestamps
    end
  end
end
