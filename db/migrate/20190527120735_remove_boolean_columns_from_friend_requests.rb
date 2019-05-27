class RemoveBooleanColumnsFromFriendRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :friend_requests, :responded
    remove_column :friend_requests, :accepted
  end
end