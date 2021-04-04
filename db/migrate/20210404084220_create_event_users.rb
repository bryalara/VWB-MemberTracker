class CreateEventUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :event_users do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :event, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
