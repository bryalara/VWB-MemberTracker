class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.datetime :startDate
      t.datetime :endDate
      t.integer :points
      t.string :name
      t.string :description
      t.string :type

      t.timestamps
    end
  end
end
