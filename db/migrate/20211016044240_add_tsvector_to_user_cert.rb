class AddTsvectorToUserCert < ActiveRecord::Migration[6.1]
  def up
    add_column :user_certificates, :tsv, :tsvector
    add_index :user_certificates, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON user_certificates FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', cert_name
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE user_certificates SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON user_certificates
    SQL

    remove_index :user_certificates, :tsv
    remove_column :user_certificates, :tsv
  end
end
