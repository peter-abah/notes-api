class AddUuidToNotes < ActiveRecord::Migration[7.0]
  def up
    add_column :notes, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :notes, :id, :integer_id
    rename_column :notes, :uuid, :id
    execute "ALTER TABLE notes drop constraint notes_pkey;"
    execute "ALTER TABLE notes ADD PRIMARY KEY (id);"

    # Optionally you remove auto-incremented
    # default value for integer_id column
    execute "ALTER TABLE ONLY notes ALTER COLUMN integer_id DROP DEFAULT;"
    change_column_null :notes, :integer_id, true
    execute "DROP SEQUENCE IF EXISTS notes_id_seq"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
