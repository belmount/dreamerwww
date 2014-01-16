class Estate 
  include Mongoid::Document
  
  store_in collection: "gpinfos"
  belongs_to :broker

  field :location, :type=> Hash
  index({location: '2d'})

  field :totalprice, :type=> Float
  field :image_1, :type=>String
  field :image_3, :type=>String
  field :images, :type => Array
  field :pub_at, :type=>String
  field :villa, :type=>String
  field :structue, :type => String
  field :area, :type=> Float
  field :built_year, :type=> String
  field :region, :type=> String
  field :intermediary, :type=> String
  field :pub_at, :type=> String
  field :end_at, :type=> String
  field :rooms, :type=> String
  field "type", :type=> String
  field :pubid , :type=> Integer


  scope :by_villa, ->(var) { where( villa: /#{var}/) }
  scope :by_region, ->(var) { where( region: /#{var}/) }
  scope :by_area, ->(var1, var2) { between( area:  Range.new(var1, var2)) }
  scope :by_price, ->(var1, var2) { between( price:  Range.new(var1, var2)) }
  scope :in_publish, ->(until_date) {where(:end_at.gte => until_date)}

  #default_scope where(:end_at.gte=> Date.new(2012, 11,23))


  def broker_name
    self[:broker]
  end

  def latitude
    self.location["latitude"]
  end

  def longitude
    self.location["longitude"]
  end

  def self.find pubid
    where(:pubid=>pubid).first
  end

  def to_param
    pubid
  end

  def agency
    Agency.where('guid'=>/#{self.intermediary}/i).first
  end

  def published_by_agency
    self.broker ? self.broker.agency.bname : 'Data error'
  end

end
