class List < ActiveRecord::Base
  attr_accessible :description, :title
  has_many :songs, :dependent => :destroy
  belongs_to :user
  validates :title, presence: true
end
