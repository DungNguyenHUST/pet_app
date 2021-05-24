class CreateCompanySalaries < ActiveRecord::Migration[6.1]
  def change
    create_table :company_salaries do |t|
      t.integer   :company_id
      t.integer   :salary
      t.string   :salary_currency
      t.string   :salary_job
      t.string   :salary_experience
      t.boolean   :salary_working_status
      t.integer   :user_id
      t.string   :user_name

      t.timestamps
    end
    add_column :company_salaries, :slug, :string
    add_index :company_salaries, :slug, unique: true
  end
end
