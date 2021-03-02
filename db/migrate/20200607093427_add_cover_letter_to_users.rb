class AddCoverLetterToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :cover_letter, :text
  end
end
