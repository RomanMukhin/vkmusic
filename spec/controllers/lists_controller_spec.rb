require "spec_helper"

describe ListsController do
  let!(:user){  FactoryGirl.create(:user, uid: "33333")}
  let!(:lists){ FactoryGirl.create_list(:list, 4, user_id: user.id)}
  before(:each) do
    session[:current_user] = "33333"
    User.any_instance.stub(:logged_in?).and_return(true)
  end  

  describe "GET #show" do
    it "gives response 200" do
      xhr :get, :show, id: lists.first.id
      response.status.should == 200
    end

    it "populates user's lists" do 
      xhr :get, :show, id: lists.first.id
      assigns(:lists).should eq(lists) 
    end
  end

  describe "POST #create" do
    it "assignes new list, makes it current" do
      xhr :post, :create
      expect(response).to render_template("lists/create")
    end
    
    it "creates new list" do
      list_attributes = FactoryGirl.attributes_for(:list)
      xhr :post, :create, list_attributes
      List.find_by_title(list_attributes[:title]).should be
    end
  end

  describe "DELETE #destroy" do
    before(:each){ session[:current_list] = lists.first.id}
    it "deletes list" do
      xhr :delete, :destroy, id: lists.first.id
      List.find_by_id(lists.first.id).should be_nil
    end
    
    it "renders its partial" do
      xhr :delete, :destroy, id: lists.first.id
      expect(response).to render_template("lists/destroy")
    end
  end
end