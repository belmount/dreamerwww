class Asset
  include Mongoid::Document
  include Mongoid::Paperclip

  has_mongoid_attached_file :attachment,
    :path           => ':rails_root/public/:attachment/:id/:style/:id.:extension',
    :styles         => {thumb: "100x100#"},
    :url            => '/:attachment/:id/:style/:id.:extension'

  validates_attachment :attachment,
            :presence => true,
            content_type: { 
              :content_type => 
                    ["image/jpg","image/jpeg", "image/gif", "image/png", #image
                     "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document",#word
                     #excel
                     "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"],
              }

  before_post_process :images?

  before_destroy :clear_attachment
  def clear_attachment
    attachment.destroy
  end

  def images?
     %w(image/jpeg image/png image/gif image/jpg).include?(attachment_content_type)
  end
end