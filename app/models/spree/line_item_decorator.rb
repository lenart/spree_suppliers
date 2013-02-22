Spree::LineItem.class_eval do
  has_one :supplier, through: :variant
end