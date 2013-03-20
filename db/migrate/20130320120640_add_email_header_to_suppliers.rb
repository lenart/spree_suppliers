class AddEmailHeaderToSuppliers < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :email_header, :text
    add_column :spree_suppliers, :email_footer, :text
  end
end
