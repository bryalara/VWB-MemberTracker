class RemoveEventTypeFromPointEvents < ActiveRecord::Migration[6.0]
  def change
    remove_column :point_events, :eventType, :string
  end
end
