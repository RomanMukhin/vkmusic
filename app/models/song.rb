class Song < ActiveRecord::Base
  acts_as_list
  
  default_scope order('position ASC')
  
  attr_accessible :artist, :duration, :title, :url, :position
  belongs_to :list
  validates :title, :artist, presence: true
end