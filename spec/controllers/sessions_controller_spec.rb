require "spec_helper"

describe SessionsController do
  let(:list){ FactoryGirl.create(:list) }
  let(:songs){ FactoryGirl.create_list(:song,3, list_id: list.id)} 
  before(:each) do
    session[:current_list] = list.id 
  end

  context "#new" do
    it "opens new session" do
      controller.should_receive(:srand)
      post :new
      session[:state].should_not be_blank
    end

    it "begins omniauth process" do
      VkontakteApi.stub(:authorization_url).and_return("http://oauth.vk.com/state?somthing&234")
      VkontakteApi.should_receive(:authorization_url).with(scope: [:offline, :audio], state: anything())
      post :new
      assigns[:vk_url].should == "http://oauth.vk.com/state?somthing&234"
    end
  end

  context "#callback" do
    before(:each) do
      session[:state] = '11111111'
    end

    it "redirects to root url if session not equils params" do 
      get :callback, state: '22222222'
      session[:token].should be_nil
      session[:vk_id].should be_nil
      response.should redirect_to root_url
    end

    it "if state is same - begin session with token and id" do 
      vk = double('vk', {token: "token", user_id: "id1111"})
      VkontakteApi.stub(:authorize).and_return(vk)
      VkontakteApi.should_receive(:authorize).with(code: 'code')
      get :callback, {state: '11111111', code: 'code'}
      session[:token].should_not be_nil
      session[:vk_id].should_not be_nil
      response.should redirect_to root_url
    end
  end

  context "#destroy" do
   before(:each) do
      session[:token] = "22222"
      @user = FactoryGirl.create(:user, token: "22222") 
      session[:vk_id] = "something"
    end

    it "destroys session" do
      delete :destroy
      User.find(@user.id).token.should be_nil
      session[:token].should be_nil
      session[:vk_id].should be_nil
    end

    it "redirects to root" do 
      delete :destroy
      response.should redirect_to root_url
    end
  end
end
