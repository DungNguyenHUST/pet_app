class AddTsvectorToUserEdu < ActiveRecord::Migration[6.1]
  def up
    add_column :user_educations, :tsv, :tsvector
    add_index :user_educations, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON user_educations FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', school_name, cert_type, school_level, school_field, cert_level
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE user_educations SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON user_educations
    SQL

    remove_index :user_educations, :tsv
    remove_column :user_educations, :tsv
  end
end
