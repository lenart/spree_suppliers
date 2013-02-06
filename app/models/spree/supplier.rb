module Spree
  class Supplier < ActiveRecord::Base
    has_many :products
    
    attr_accessible :description, :email, :name
    
    validates_presence_of :name
  end
end