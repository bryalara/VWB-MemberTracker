# frozen_string_literal: true

class AddDeviseToUserlogins < ActiveRecord::Migration[6.0]
  def self.up
    create_table :userlogins do |t|
      t.string :email, null: false
      t.string :full_name
      t.string :uid
      t.string :avatar_url

      t.timestamps null: false
    end

  add_index :userlogins, :email, unique: true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
