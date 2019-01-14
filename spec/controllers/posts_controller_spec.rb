require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  describe "GET #show" do
    before :each do
      @author = create(:user)
      @postable_user = create(:user)
      @post = create(:user_post, author_id: @author.id, postable_id: @postable_user.id)
      sign_in(@author)
      get :show, params:{id:@post.id}
    end

    it "renders the post show page" do
      expect(response).to render_template("show")
    end

    it "assigns to @post" do
      expect(assigns(:post)).to eq(@post)
    end
  end


  describe "POSt #create" do
    it "saves to the database" do
      author = create(:user)
      postable_user = create(:user)
      sign_in(author)
      expect do
        post :create, params: {
          post: {
            postable_id: postable_user.id,
            author_id: author.id,
            body: Faker::Lorem.paragraph(2)
          }
        }
      end.to change(Post,:count).by(1)
    end

    context "instance variable assignment and redirection" do
      before :each do
        @author = create(:user)
        @postable_user = create(:user)
        parameters = {params:{post:attributes_for(:user_post, postable_id: @postable_user.id, author_id: @author.id)}}
        sign_in(@author)
        post :create, parameters
      end

      it "assigns to @postable" do
        expect(assigns(:postable)).to eq(@postable_user)
      end

      it "assigns to @author" do
        expect(assigns(:author)).to eq(@author)
      end

      it "redirects successfully" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #edit" do
    
  end

end
