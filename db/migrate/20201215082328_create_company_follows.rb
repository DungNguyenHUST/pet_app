class CreateCompanyFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :company_follows do |t|
      t.timestamps
    end
  end
end
