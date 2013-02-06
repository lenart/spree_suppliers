Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                    :name => "add_supplier_field_to_product_form",
                    :insert_bottom => "[data-hook='admin_product_form_right']",
                    :partial => "spree/admin/products/supplier_field",
                    :disabled => false)