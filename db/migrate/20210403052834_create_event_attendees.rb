class CreateEventAttendees < ActiveRecord::Migration[6.0]
  def change
    create_table :event_attendees, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, type: :uuid
      t.belongs_to :event, foreign_key: true, type: :uuid
      t.boolean :attended, null: false, default: false
      t.timestamps
    end

    add_index :event_attendees, [:user_id, :event_id], :unique => true
  end
end
