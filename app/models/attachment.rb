class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  
  has_attached_file :file
  
  validates_attachment_content_type :file, content_type: [/\Aimage\/(bmp|jpg|jpeg|png)\Z/, /\Aapplication\/pdf\Z/]
  
end
