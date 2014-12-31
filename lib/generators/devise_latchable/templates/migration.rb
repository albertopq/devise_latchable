class DeviseAddLatchAccountId<%= table_name.camelize.singularize %> < ActiveRecord::Migration
  def self.up
    add_column :<%= table_name %>, :latch_account_id, :string
  end

  def self.down
    remove_column :<%= table_name %>, :latch_account_id
  end
end
