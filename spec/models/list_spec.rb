require "spec_helper"

describe List do
  it { should_not allow_mass_assignment_of(:id)}
  it { should validate_presence_of(:title)}
  it { should have_many(:songs) }
  it { should belong_to(:user)}

  it "is valid with title anyways" do
    FactoryGirl.build(:list).should be_valid
    FactoryGirl.build(:list, description: nil).should be_valid
  end
end