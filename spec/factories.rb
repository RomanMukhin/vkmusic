FactoryGirl.define do
  factory :user do 
	  name "Name"
	  token "23rr3r2e2d2d2s"
	  uid "111111" 
  end

  factory :list do |f|
    f.title "Foo"
    f.description "Description"
    f.association :user
  end

  factory :song do |f|
  	f.artist "artist"
  	f.duration "200"
  	f.title "title"
  	f.url "http://url.net/242e2e"
    f.position{ |u| u.id }
  	#f.sequence(:position){|s| s}
  end
end

#attr_accessible :artist, :duration, :title, :url, :position