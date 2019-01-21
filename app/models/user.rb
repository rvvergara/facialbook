# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy

  # User is post author
  has_many :posts, foreign_key: :author_id, dependent: :destroy

  # User is post receiver
  has_many :posts, as: :postable, dependent: :destroy

  has_many :comments, foreign_key: :author_id, dependent: :destroy

  has_many :likes, foreign_key: :liker_id, dependent: :destroy

  has_many :active_friendships, class_name: 'Friendship', foreign_key: :user_id

  has_many :passive_friendships, class_name: 'Friendship', foreign_key: :friend_id

  has_many :added_friends, through: :active_friendships,
                           source: :friend

  has_many :adding_friends, through: :passive_friendships, source: :user

  has_many :active_requests, class_name: 'FriendRequest', foreign_key: :requester_id

  has_many :passive_requests, class_name: 'FriendRequest', foreign_key: :requestee_id

  has_many :requestees, through: :active_requests

  has_many :requesters, through: :passive_requests

  accepts_nested_attributes_for :profile, allow_destroy: true
  def friends
    added_friends + adding_friends
  end

  def mutual_friends(friend)
    friends & friend.friends
  end

  def friendships
    Friendship.where('user_id=? OR friend_id=?', id, id)
  end

  def pending_request?(requestee)
    pending = active_requests.where('responded=? AND requestee_id=?', false, requestee.id)[0]
    return false if pending.nil?

    !pending.responded
  end

  def pending_passive_requests
    passive_requests.where('responded=?', false)
  end

  def build_post(postable)
    postable.posts.build(author_id: id)
  end

  def liked_post
    Post.joins(:likes).where('liker_id=?', id)
  end

  def liked_comment
    Comment.joins(:likes).where('liker_id=?', id)
  end
end
