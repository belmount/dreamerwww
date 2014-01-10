
class Complain
  include Mongoid::Document
  store_in collection: "complain"

  field :contract_no, :type=> String
  field :contract_type, :type=> String
  field :complain_by, :type=> String
  field :phone, :type=> String
  field :content, :type=> String
  field :complain_item, :type=> String
  field :complain_to, :type=>String

  validates :contract_no, presence: true
  validates :contract_type, presence: true
  validates :complain_by, presence:true
  validates :phone, presence:true, length:{:minimum=>8, :maximum => 11}, format:{with: /\d+/}
  validates :content, length:{:maximum=>200} 
  validates :complain_item, presence:true
  validates :complain_to, presence:true
end