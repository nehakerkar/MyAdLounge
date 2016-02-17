class Adgroup < ActiveRecord::Base
 belongs_to :campaign
 has_many :ads
  
 before_save { self.aname = aname.downcase }
 validates :campaign_id, presence: true
 validates :aname, presence: true
 VALID_URL_REGEX = /\A(https?:\/\/)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/i
 validates :displayurl, presence: true, length: { maximum: 255 }, format: { with: VALID_URL_REGEX }
 validates :finalurl, presence: true, length: { maximum: 255 }, format: { with: VALID_URL_REGEX }
end
