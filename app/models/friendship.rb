# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  default_scope { eager_load(:user).eager_load(:friend) }

  before_save :concatenate_ids
  after_save :delete_associated_request

  def self.between(user, friend)
    where('concatenated=?', [user.id, friend.id].sort.join)[0]
  end

  private

  def concatenate_ids
    self.concatenated = [user.id, friend.id].sort.join
  end

  def delete_associated_request
    request = FriendRequest.where('concatenated=?', concatenated)[0]
    request&.delete
  end
end
