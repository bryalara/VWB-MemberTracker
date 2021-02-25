class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.datetime :startDate
      t.datetime :endDate
      t.integer :points
      t.string :eventType

      t.timestamps
    end
  end
end
