class AddTsvectorToUserSkill < ActiveRecord::Migration[6.1]
  def up
    add_column :user_skills, :tsv, :tsvector
    add_index :user_skills, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON user_skills FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', skill_name, skill_level
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE user_skills SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON user_skills
    SQL

    remove_index :user_skills, :tsv
    remove_column :user_skills, :tsv
  end
end
