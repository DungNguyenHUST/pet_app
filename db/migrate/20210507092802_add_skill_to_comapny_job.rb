class AddSkillToComapnyJob < ActiveRecord::Migration[6.1]
  def change
	add_column :company_jobs, :skill, :text, array: true, default: []
  end
end
