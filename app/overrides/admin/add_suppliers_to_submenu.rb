Deface::Override.new( virtual_path: "spree/admin/shared/_product_sub_menu",
                      name: "add_suppliers_to_admin_nav",
                      insert_bottom: "[data-hook='admin_product_sub_tabs']",
                      text: "<%= tab(:suppliers) %>",
                      original: 'c688254a7a0634df055e19c61e8c59265f1c9b6b' 
                    )

# Highlight Products tab