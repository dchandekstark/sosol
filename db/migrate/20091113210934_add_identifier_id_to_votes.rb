class AddIdentifierIdToVotes < ActiveRecord::Migration[4.2]
  def self.up
    add_column :votes, :identifier_id, :integer
  end

  def self.down
   remove_column :votes, :identifier_id
  end
end
