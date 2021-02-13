class CreatePointEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :point_events do |t|
      t.integer :points
      t.string :name
      t.string :description
      t.string :type

      t.timestamps
    end
  end
end
