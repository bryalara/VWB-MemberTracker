class CreateEdithomepages < ActiveRecord::Migration[6.0]
  def change
    create_table :edithomepages, id: :uuid do |t|
      t.string :name
      t.string :description
      t.string :h1
      t.string :d1
      t.string :h2
      t.string :d2

      t.timestamps
    end
  end
end
