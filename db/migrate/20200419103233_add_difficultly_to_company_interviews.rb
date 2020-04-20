class AddDifficultlyToCompanyInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :company_interviews, :difficultly, :integer
  end
end
