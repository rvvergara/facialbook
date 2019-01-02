require 'rails_helper'

RSpec.describe FriendRequestsController, type: :controller do
  describe '#create' do
    it 'saves to the database' do
      requestee = create(:user)
      requester = create(:user)

      sign_in(requester)
      expect {
        post :create, params: {
          friend_request: { requestee_id: requestee.id, requester_id: requester.id }
        }
      }.to change(FriendRequest, :count).by(1)
    end

    context 'instance variable assignments and redirection' do
      before(:each) do
        @requestee = create(:user)
        @requester = create(:user)

        parameters = { params: { friend_request: attributes_for(:friend_request, requester_id: @requester.id, requestee_id: @requestee.id) } }

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
        expect(response).to redirect_to(user_path(@requester))
      end
    end
  end
end
