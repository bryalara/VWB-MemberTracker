class PointEventsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :point_events_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :point_event
      t.timestamps
    end
  end
end
