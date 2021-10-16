class AddTsvectorToCompany < ActiveRecord::Migration[6.1]
  def up
    add_column :companies, :tsv, :tsvector
    add_index :companies, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON companies FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', name
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE companies SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON companies
    SQL

    remove_index :companies, :tsv
    remove_column :companies, :tsv
  end
end
