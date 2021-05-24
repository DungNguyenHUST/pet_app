class CreateCompanyQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :company_questions do |t|
      t.string   :title
      t.text   :content

      t.timestamps
    end
  end
end
