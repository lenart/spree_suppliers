module Spree
  class Supplier < ActiveRecord::Base
    attr_accessible :description, :email, :name

    validates_presence_of :name
  end
end