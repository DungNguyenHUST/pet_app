class DropCovertCol < ActiveRecord::Migration[6.1]
  def change
    if column_exists? :companies, :name_converted
      remove_column :companies, :name_converted
    end
    if column_exists? :companies, :location_converted
      remove_column :companies, :location_converted
    end

    if column_exists? :company_jobs, :title_converted
      remove_column :company_jobs, :title_converted
    end
    if column_exists? :company_jobs, :location_converted
      remove_column :company_jobs, :location_converted
    end
    if column_exists? :company_jobs, :category_converted
      remove_column :company_jobs, :category_converted
    end
    if column_exists? :company_jobs, :company_name_converted
      remove_column :company_jobs, :company_name_converted
    end
    if column_exists? :company_jobs, :level_converted
      remove_column :company_jobs, :level_converted
    end
    if column_exists? :company_jobs, :skill_converted
      remove_column :company_jobs, :skill_converted
    end
    if column_exists? :company_jobs, :typical_converted
      remove_column :company_jobs, :typical_converted
    end
    if column_exists? :company_jobs, :experience_converted
      remove_column :company_jobs, :experience_converted
    end

    if column_exists? :posts, :title_converted
      remove_column :posts, :title_converted
    end

    if column_exists? :problems, :title_converted
      remove_column :problems, :title_converted
    end
  end
end
