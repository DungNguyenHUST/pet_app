class CreateCompanyJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :company_jobs do |t|
      t.string :title
      t.text :description
      t.text :requirement
      t.text :benefit
      t.integer :salary
      t.string :quantity
      t.string :category

      t.timestamps
    end
  end
end
