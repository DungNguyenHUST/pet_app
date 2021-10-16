class AddTsvectorToUserExp < ActiveRecord::Migration[6.1]
  def up
    add_column :user_experiences, :tsv, :tsvector
    add_index :user_experiences, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON user_experiences FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', job_level, company_name
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE user_experiences SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON user_experiences
    SQL

    remove_index :user_experiences, :tsv
    remove_column :user_experiences, :tsv
  end
end
