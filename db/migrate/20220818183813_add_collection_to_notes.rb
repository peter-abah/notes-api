class AddCollectionToNotes < ActiveRecord::Migration[7.0]
  def change
    add_reference :notes, :collection, type: :uuid, foreign_key: true
  end
end
