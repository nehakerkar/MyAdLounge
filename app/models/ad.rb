class Ad < ActiveRecord::Base
  belongs_to :adgroup
  before_save { self.keyword = keyword.downcase }
  validates :keyword, presence: true
  validates :adgroup_id, presence: true
end
