class Law
  include Mongoid::Document
  store_in collection: "law", session: "default"
  include Mongoid::TaggableWithContext
  include Mongoid::TaggableWithContext::AggregationStrategy::RealTime


  field :content, :type=> String
  field :title, :type =>String
  field :publish_at, :type => DateTime
  field :is_news, :type=>Boolean

  taggable :separator => ','

  validates_presence_of :title 

  scope :type, lambda{|n| where(:is_news => n)}
  scope :laws, type(false)
  scope :news, type(true)
  
  def self.session
    Mongoid.default_session
  end

  def to_param
    title
  end

  def self.find param
    where(:title=>param).first
  end
end
