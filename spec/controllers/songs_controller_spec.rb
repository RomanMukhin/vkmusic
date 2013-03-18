require "spec_helper"

describe SongsController do
  let(:list){  FactoryGirl.create(:list) }
  let(:songs){ FactoryGirl.create_list(:song, 3, list_id: list.id)} 
  let(:song){ song = FactoryGirl.create(:song) }
  before(:each) do
    session[:current_list] = list.id 
  end

  context "#create" do
    let(:song_attributes){ FactoryGirl.attributes_for(:song) }
    it "creates new songs with valid song params" do 
      xhr :post, :create, song: song_attributes
      a,t = song_attributes.values_at(:artist,:title)
      Song.where("artist = ? AND title = ?", a, t).should_not be_blank
    end

    it "renders its partial" do
      xhr :post, :create, song: song_attributes
      expect(response).to render_template("songs/create")
    end

    it "doesnt create new song with invalid params" do
      song_attributes = FactoryGirl.attributes_for(:song, artist: "") 
      xhr :post, :create, song: song_attributes
      a,t = song_attributes.values_at(:artist,:title)
      Song.where("artist = ? AND title = ?", a, t).should be_blank
    end
  	
    it "it finds current list and decorates" do 
      session[:current_list] = 3
      list = FactoryGirl.create(:list, id: 3)
      xhr :post, :create
      assigns[:list].id.should == 3
      assigns[:list].should be_decorated
    end
  end

  context "#destroy" do
    it "destroys a song" do 
      xhr :delete, :destroy, id: song.id
      Song.find_by_id(song.id).should == nil
      assigns[:list].should be_decorated
    end

    it "renders its template" do 
      xhr :delete, :destroy, id: song.id
      expect(response).to render_template("songs/destroy")
    end
  end

  context "#download" do
    it"downloads the song" do 
      controller.stub!(:render)
      resp = double("resp").as_null_object
      controller.stub(:download_audio).and_return(resp)
      controller.stub(:temp_file_sending).and_return(:send_file)
      controller.should_receive(:download_audio).with(song.url)
      controller.should_receive(:temp_file_sending).with("artist - title", resp).and_call_original
      controller.should_receive(:send_file)
      xhr :post, :download, id: song.id
    end
  end
  
  context "#sort" do
     it "renders nothing" do
  	ListDecorator.stub(:find).and_return(FactoryGirl.build(:list))
  	FactoryGirl.create(:song)
  	xhr :post, :sort
  	response.body.should be_blank
     end

     it "gives new positions in list" do
  	xhr :post, :sort, song: [songs[0].id, songs[2].id, songs[1].id]
  	Song.find(songs[2].id).position.should == songs[1].position
     end
  end
end
