class CreateCompanyReplyQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :company_reply_questions do |t|
      t.integer   :company_question_id
      t.text   :reply_content
      t.integer   :user_id
      t.string   :user_name
      t.timestamps
    end
    
    add_column :company_reply_questions, :slug, :string
    add_index :company_reply_questions, :slug, unique: true
  end
end
