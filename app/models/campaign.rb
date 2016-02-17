class Campaign < ActiveRecord::Base
  belongs_to :user
  has_many :adgroups
  
  before_save { self.cname = cname.downcase }
  validates :cname, presence: true
end
