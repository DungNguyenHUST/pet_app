class AddProfileToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthday, :datetime
    add_column :users, :sex, :string
    add_column :users, :matrimony, :string
    add_column :users, :headline, :string
    add_column :users, :summary, :text
    add_column :users, :highest_education, :string
    add_column :users, :highest_career, :string
    if column_exists? :users, :root
      remove_column :users, :root
    end
    if column_exists? :users, :admin
      remove_column :users, :admin
    end
    if column_exists? :users, :user
      remove_column :users, :user
    end
    if column_exists? :users, :employer
      remove_column :users, :employer
    end
    if column_exists? :users, :company
      remove_column :users, :company
    end
    if column_exists? :users, :company_id
      remove_column :users, :company_id
    end
  end
end
