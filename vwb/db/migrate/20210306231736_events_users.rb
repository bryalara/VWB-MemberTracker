class EventsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :events_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :event
      t.timestamps
    end
  end
end
