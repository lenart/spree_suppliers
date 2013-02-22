Spree::Variant.class_eval do
  has_one :supplier, through: :product
end