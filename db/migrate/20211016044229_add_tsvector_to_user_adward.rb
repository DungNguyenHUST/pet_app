class AddTsvectorToUserAdward < ActiveRecord::Migration[6.1]
  def up
    add_column :user_adwards, :tsv, :tsvector
    add_index :user_adwards, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON user_adwards FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', adward_name
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE user_adwards SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON user_adwards
    SQL

    remove_index :user_adwards, :tsv
    remove_column :user_adwards, :tsv
  end
end
