class CreateCompanyInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :company_interviews do |t|
      t.string :user_name
      t.string :position
      t.string :content

      t.timestamps
    end
  end
end
