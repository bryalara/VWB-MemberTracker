class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.integer :role
      t.string :firstName
      t.string :lastName
      t.string :phoneNumber
      t.string :classification
      t.string :tShirtSize
      t.boolean :optInEmail
      t.integer :participationPoints

      t.timestamps
    end
  end
end
