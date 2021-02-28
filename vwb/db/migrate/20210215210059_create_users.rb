class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email,                null: false, default: "emailneeded" 
      t.integer :role,                null: false, default: 0 
      t.string :firstName,            null: false, default: "FirstName" 
      t.string :lastName,             null: false, default: "LastName" 
      t.string :phoneNumber,          null: false, default: "1234567890" 
      t.string :classification,       null: false, default: "Freshmen" 
      t.string :tShirtSize,           null: false, default: "M" 
      t.boolean :optInEmail,          null: false, default: true 
      t.integer :participationPoints, null: false, default: 0 
      t.boolean :approved,            null: false, default: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
