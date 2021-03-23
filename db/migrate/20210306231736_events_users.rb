class EventsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :events_users, id: false do |t|
      t.belongs_to :user, foreign_key: true, type: :uuid
      t.belongs_to :event, foreign_key: true, type: :uuid
      t.timestamps
    end

    add_index :events_users, [:user_id, :event_id], :unique => true
  end
end
