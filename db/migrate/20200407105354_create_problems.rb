class CreateProblems < ActiveRecord::Migration[6.0]
  def change
    create_table :problems do |t|
      t.string :user_name
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
