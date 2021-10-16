class AddTsvectorToProblem < ActiveRecord::Migration[6.1]
  def up
    add_column :problems, :tsv, :tsvector
    add_index :problems, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON problems FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', title
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE problems SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON problems
    SQL

    remove_index :problems, :tsv
    remove_column :problems, :tsv
  end
end
