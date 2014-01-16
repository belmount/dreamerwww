# encoding: UTF-8
class Agency 
  include Mongoid::Document
  store_in collection: "agency"
  
  include Mongoid::TaggableWithContext
  include Mongoid::TaggableWithContext::AggregationStrategy::RealTime

  field :location, :type => Hash
  index({ location: "2d" })

  field :area, :type=> String
  field :bname, :type=> String
  field :tel, :type=> String
  field :address, :type=> String
  field :complain_cnt, :type=> Integer
  field :guid, :type=> String

  def self.session
    Mongoid.default_session
  end

  def self.find bname
    where(:bname=>bname).first
  end

  def to_param
    bname
  end

  taggable :awards

  taggable :separator => ','

  has_many :brokers

  def latitude
    self.location["latitude"]
  end

  def longitude
    self.location["longitude"]
  end


  def gmaps4rails_title
       "#{self.bname}"
  end


  def self.thumb_url img
    "http://119.97.201.21/zj/pages/orgthumbs/#{img["guid"]}"
  end


  def self.orig_url img
    "http://119.97.201.21/zj/pages/orgimages/#{img["guid"]}.jpg"
  end

  def in_complain?
    complain_cnt.present? and complain_cnt > 0
  end

  DOWNTOWN = ['武昌区','江岸区','青山区', '硚口区','江岸区','汉阳区','江汉区', '洪山区','东湖高新技术开发区']
  SUBURBS =  ['东西湖区','黄陂区','江夏区','蔡甸区','武汉经济技术开发区','新洲区']
  scope :inter, where(level: /居间/)
  scope :proxy, where(level: /代理/)
  scope :downtown, where(:area.in=> DOWNTOWN)
  scope :suburbs, where(:area.in=> SUBURBS)

  # to remove companies without location to result
  scope :locable, where(:location.ne => nil)
end
