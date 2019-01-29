# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    session[:return_to] = request.url
    if user_signed_in?
      if !current_user.profile.nil?
        @posts = Post.user_newsfeed_posts(current_user)
      else
        redirect_to new_user_profile_path(current_user)
      end
    end
  end
end
