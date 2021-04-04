class CreatePointEventUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :point_event_users do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :point_event, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
