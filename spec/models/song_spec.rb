require "spec_helper"

describe Song do
  it { should_not allow_mass_assignment_of(:id)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:artist)}
  it { should belong_to(:list) }
  
  it "builds a valid song" do
    song = FactoryGirl.build(:song)
    song.should be_valid
  end

  it "is ordered by position ASC" do
    FactoryGirl.create_list(:user, 25)
    Song.all.should == Song.order("position ASC").all
  end
end