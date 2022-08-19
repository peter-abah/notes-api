class CreateTagsNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :tags_notes, id: false do |t|
      t.references :note, type: :uuid, index: true, foreign_key: true, null: false
      t.references :tag, type: :uuid, index: true, foreign_key: true, null: false

      t.index [:tag_id, :note_id]
      t.index [:note_id, :tag_id]
    end
  end
end
