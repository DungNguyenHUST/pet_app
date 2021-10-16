class AddTsvectorToCompanyJob < ActiveRecord::Migration[6.1]
  def up
    add_column :company_jobs, :tsv, :tsvector
    add_index :company_jobs, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON company_jobs FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', title, company_name, category, location, typical, level
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE company_jobs SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON company_jobs
    SQL

    remove_index :company_jobs, :tsv
    remove_column :company_jobs, :tsv
  end
end
