# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendRequestsController, type: :controller do
  describe '#create' do
    it 'saves to the database' do
      requestee = create(:user)
      requester = create(:user)
      session[:return_to] = user_path(requestee)
      sign_in(requester)
      expect do
        post :create, params: {
          friend_request: { requestee_id: requestee.id, requester_id: requester.id }
        }
      end.to change(FriendRequest, :count).by(1)
    end

    context 'instance variable assignments and redirection' do
      before(:each) do
        @requestee = create(:user)
        @requester = create(:user)

        parameters = { params: { friend_request: attributes_for(:friend_request, requester_id: @requester.id, requestee_id: @requestee.id) } }
        session[:return_to] = user_path(@requestee)
        sign_in(@requester)
        post :create, parameters
      end

      it 'Assigns to @requester' do
        expect(assigns(:requester)).to eq(@requester)
      end

      it 'Assigns to @requestee' do
        expect(assigns(:requestee)).to eq(@requestee)
      end

      it 'redirects' do
        expect(response).to redirect_to(user_path(@requestee))
      end
    end
  end

  describe '#destroy' do
    it 'deletes from the database' do
      requestee = create(:user)
      requester = create(:user)
      friend_request = create(:friend_request, requester_id: requester.id, requestee_id: requestee.id)
      sign_in(requestee)
      session[:return_to] = user_path(requestee)
      expect do
        delete :destroy, params: {
          id: friend_request.id
        }
      end.to change(FriendRequest, :count).by(-1)
    end

    context 'variable assignment and redirection' do
      before(:each) do
        @requestee = create(:user)
        @requester = create(:user)
        @friend_request = create(:friend_request, requester_id: @requester.id, requestee_id: @requestee.id)
        parameters = { params: { id: @friend_request.id } }
        session[:return_to] = @requestee
        sign_in(@requestee)
        delete :destroy, parameters
      end

      it 'assigns to @friend_request' do
        expect(assigns(:friend_request)).to eq(@friend_request)
      end

      it 'redirects back after delete' do
        expect(response).to redirect_to user_path(@requestee)
      end
    end
  end
end
