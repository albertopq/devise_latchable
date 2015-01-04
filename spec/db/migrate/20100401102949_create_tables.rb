class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              :null => true, :default => ""
      t.string :encrypted_password, :null => true, :default => ""

      # uid
      t.string :latch_account_id

      t.timestamps
    end

  end
end
