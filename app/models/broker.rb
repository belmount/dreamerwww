class Broker 
	include Mongoid::Document
	include Mongoid::TaggableWithContext
  include Mongoid::TaggableWithContext::AggregationStrategy::RealTime
	
	store_in collection: 'broker'

  def self.session
    Mongoid.default_session
  end
	
	taggable :awards
	belongs_to :agency
  has_many :estates

  def self.img_url guid
    "http://119.97.201.21/zj/FileUpload/BrokerImages/#{guid}.jpg"
  end

  default_scope asc(:type)
end
