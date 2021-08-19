class DropCkeditor < ActiveRecord::Migration[6.1]
  def change
    if table_exists? :ckeditor_assets
      drop_table :ckeditor_assets
    end
  end
end
