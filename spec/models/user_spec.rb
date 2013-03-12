require "spec_helper"

describe User do
  it { should validate_presence_of(:uid)}
  it { should have_many(:lists) }
  it { should_not allow_mass_assignment_of(:id)}

  it "creates saves newcomming vald user" do
    user1 = FactoryGirl.build(:user)
    User.authorization("Name", "111111", "23rr3r2e2d2d2s")
    user2 = User.find_by_name("Name")

    user1.name.should  == user2.name
    user1.uid.should   == user2.uid
    user1.token.should == user2.token
  end

  it "doesnt create new user if exists" do
    FactoryGirl.create(:user)
    User.find_all_by_name("Name").should have(1).items
    User.authorization("Name", "111111", "23rr3r2e2d2d2s")
    User.find_all_by_name("Name").should have(1).items
  end
end