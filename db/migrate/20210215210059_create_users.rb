class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email,                null: false
      t.integer :role,                null: false, default: 0 
      t.string :firstName,            null: false 
      t.string :lastName,             null: false
      t.string :phoneNumber,          null: false
      t.string :classification,       null: false
      t.string :tShirtSize,           null: false
      t.boolean :optInEmail,          null: false, default: true 
      t.integer :participationPoints, null: false, default: 0 
      t.boolean :approved,            null: false, default: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
