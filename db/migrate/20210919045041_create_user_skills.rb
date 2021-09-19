class CreateUserSkills < ActiveRecord::Migration[6.1]
  def change
    create_table :user_skills do |t|
      t.references :user, null: false, foreign_key: true
      t.string "skill_name"
      t.string "skill_summary"
      t.string "skill_level"

      t.timestamps
    end
  end
end
