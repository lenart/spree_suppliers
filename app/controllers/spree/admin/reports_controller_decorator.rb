# encoding: utf-8
Spree::Admin::ReportsController.class_eval do

  before_filter :kludge_suppliers
  
  # A dirty way to add this report to the list of Reports
  def kludge_suppliers
    return if Spree::Admin::ReportsController::AVAILABLE_REPORTS.has_key?(:suppliers_orders)
    Spree::Admin::ReportsController::AVAILABLE_REPORTS.merge!({
      :suppliers_orders => {:name => 'Suppliers Orders', :description => 'Ordered products by supplier'}
      })
  end

  def suppliers_orders
    # TODO Izberi ustrezen kriterij za prikaz narocil glede na payment_state
    # paid          when +payment_total+ is equal to +total+
    # balance_due   when +payment_total+ is less than +total+
    # credit_owed   when +payment_total+ is greater than +total+
    # failed        when most recent payment is in the failed state
    
    params[:q] = {} unless params[:q]
    params[:q][:meta_sort] = "number.asc"
    params[:q][:payment_state_in] = %w(balance_due paid)

    # If Order Number is given find it and select products newer than the order
    if params[:q].has_key?(:order_number_gt) && !params[:q][:order_number_gt].blank?
      @starting_order = Spree::Order.where(number: params[:q][:order_number_gt]).first
      params[:q][:completed_at_gteq] = @starting_order.completed_at
      params[:q].delete(:order_number_gt)
    end

    @search = Spree::Order.ransack(params[:q])
    @orders = @search.result(:uniq => true)

    # Loop through scoped orders, get the suppliers and count products quantity for each
    # Idea for refactoring - make a service object
    #   @quantities = SupplierProductCounter.new @orders
    #
    supplier_ids = []
    @product_quantities = {}

    @orders.each do |order|
      # Get all suppliers involved (in orders)
      supplier_ids << order.products.collect(&:supplier_id)

      # Get product quantities
      order.line_items.each do |item|
        supplier = item.supplier.id # get Supplier ID through association

        if @product_quantities.has_key? supplier
          if @product_quantities[supplier].has_key? item.variant_id
            @product_quantities[supplier][item.variant_id] += item.quantity
          else
            @product_quantities[supplier][item.variant_id] = item.quantity
          end
        else
          @product_quantities[supplier] = { item.variant_id => item.quantity }
        end
      end

    end
    # @suppliers = Spree::Supplier.where(id: supplier_ids.uniq)
  end

end