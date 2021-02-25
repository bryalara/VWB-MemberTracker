class CreateIdentifies < ActiveRecord::Migration[6.0]
  def change
    create_table :identifies do |t|
      t.integer :user_id
      t.text :provider
      t.text :uid

      t.timestamps
    end
  end
end
