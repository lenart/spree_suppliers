class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :spree_suppliers do |t|
      t.string :name
      t.string :email
      t.text :description

      t.timestamps
    end
  end
end
