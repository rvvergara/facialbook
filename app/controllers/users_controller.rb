# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user
  before_action :authenticate_user!
  def index; end

  def show
    session[:return_to] = request.url
    @profile = @user.profile
    @posts = Post.timeline_posts(@user)
  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
  end
end
