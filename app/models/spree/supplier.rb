module Spree
  class Supplier < ActiveRecord::Base
    has_many :products
    
    attr_accessible :name, :email, :description, :email_header, :email_footer
    
    validates_presence_of :name
    validates_format_of :email, with: /^.+@.+$/, allow_blank: true
  end
end