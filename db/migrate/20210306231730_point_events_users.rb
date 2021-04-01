class PointEventsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :point_events_users, id: false do |t|
      t.belongs_to :user, foreign_key: true, type: :uuid
      t.belongs_to :point_event, foreign_key: true, type: :uuid
      t.timestamps
    end

    add_index :point_events_users, [:user_id, :point_event_id], :unique => true
  end
end
