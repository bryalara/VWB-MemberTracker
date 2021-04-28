class CreateOfficers < ActiveRecord::Migration[6.0]
  def change
    create_table :officers, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :description

      t.timestamps
    end
  end
end
