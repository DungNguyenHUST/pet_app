class RemoveColumeJob < ActiveRecord::Migration[6.1]
  def change
    if column_exists? :company_jobs, :type
      remove_column :company_jobs, :type 
    end

    if column_exists? :company_jobs, :job_type
      rename_column :company_jobs, :job_type, :typical
    end
  end
end
