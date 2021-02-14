class CreatePointEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :point_events do |t|
      t.string :name
      t.string :description
      t.integer :points
	  t.string :eventType

      t.timestamps
    end
  end
end
