class AddTsvectorToPost < ActiveRecord::Migration[6.1]
  def up
    add_column :posts, :tsv, :tsvector
    add_index :posts, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON posts FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', title
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE posts SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON posts
    SQL

    remove_index :posts, :tsv
    remove_column :posts, :tsv
  end
end
