class CreatePointEventAttendees < ActiveRecord::Migration[6.0]
  def change
    create_table :point_event_attendees, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, type: :uuid
      t.belongs_to :point_event, foreign_key: true, type: :uuid
      t.boolean :attended, null: false, default: false
      t.timestamps
    end

    add_index :point_event_attendees, [:user_id, :point_event_id], :unique => true
  end
end
