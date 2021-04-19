class CreateEdithomepages < ActiveRecord::Migration[6.0]
  def change
    create_table :edithomepages, id: :uuid do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
