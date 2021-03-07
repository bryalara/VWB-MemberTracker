class RemoveEventTypeFromEvents < ActiveRecord::Migration[6.0]
  def change
    remove_column :events, :eventType, :string
  end
end
