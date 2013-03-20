SpreeSuppliers
==============

A Lekarnar.com module for reveiewing purchased items and ordering additional new items from suppliers.


Installation
=============

    gem 'spree_suppliers'

Add javascript and stylesheets to your assets

    # app/assets/admin/all.js
    //= require admin/spree_suppliers

    # app/assets/stylesheets/all.css
    //* require admin/spree_suppliers


Example
=======

http://localhost:3000/admin/reports/suppliers_orders


Todo
=====



Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2013 Lenart Rudel, released under the New BSD License
