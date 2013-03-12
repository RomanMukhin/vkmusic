require "spec_helper"

describe MainController do

  before(:each) do
 
  end  

  describe "GET #search" do
    it "gives response 200" do
      User.any_instance.stub(:logged_in?).and_return(true)
      audio_hash = double("audio_hash").as_null_object
      User.stub(:vk_obj).and_return(audio_hash)
      audio_hash.stub(:decorate_collection).and_return(audio_hash)
      audio_hash.stub_chain(:paginate_array,:page,:per).and_return(audio_hash)
      Kaminari = double("Kaminari").as_null_object
      User.should_receive(:vk_obj).ordered
      SongDecorator.should_receive(:decorate_collection).with(audio_hash).ordered
      Kaminari.should_receive(:paginate_array).ordered
      #audio_hash.should_receive(:page).ordered
      xhr :get, :search, q: "smthing"
      
      response.status.should == 200
    end

    it "populates user's lists" 
  end

  describe "POST #create" do
    xit "assignes new list, makes it current" do
      xhr :post, :create
      expect(response).to render_template("lists/create")
    end
    
    xit "creates new list" do
      list_attributes = FactoryGirl.attributes_for(:list)
      xhr :post, :create, list_attributes
      List.find_by_title(list_attributes[:title]).should be
    end
  end

  describe "DELETE #destroy" do
    before(:each){ session[:current_list] = lists.first.id}
    xit "deletes list" do
      xhr :delete, :destroy, id: lists.first.id
      List.find_by_id(lists.first.id).should be_nil
    end
    
    xit "renders its partial" do
      
    end
  end
end