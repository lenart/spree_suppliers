# http://ivaynberg.github.com/select2/#documentation
jQuery ->
  new_row_template = Handlebars.compile($('#suppliers-new-product-row').html())
  input_field = $("<input type='text' value='' />")

  $('table.index td.quantity').on 'click', ->
    if ($(this).children('input').size() == 0)
      field = input_field.clone()
      field.val($(this).html())
      $(this).html field

  $(".variant_autocomplete").select2
    placeholder: "Select a variant"
    minimumInputLength: 4
    ajax:
      url: Spree.routes.variants_search
      datatype: "json"
      data: (term, page) ->
        q: term
      results: (data, page) ->
        results: data

    # We use Spree built-in template which should already be loaded
    formatResult: formatVariantResult
    
    # Text displayed in the select menu
    formatSelection: (product) ->
      $(@element).parents("fieldset").data
        sku: product.sku
        name: product.name
      product.name

  $('[data-hook="add_button"]').on "click", ->
    $fieldset = $(this).parents("fieldset")
    sku = $fieldset.data("sku")
    name = $fieldset.data("name")
    qty = $fieldset.find('[data-hook="add_quantity"] input').val()

    return false unless sku

    $table = $(this).parents('.supplier_products_table').find('tbody')
    $table.append(new_row_template({name: name, sku: sku, qty: qty}))

    # Reset fields
    $fieldset.data("sku", "").data("name", "").data("qty", 0)

    return false

  $('[data-hook="send_button"]').on "click", ->
    window.report = new SuppliersEmailReport $(this).parents('.supplier_products_table')
    return false


class SuppliersEmailReport

  template: Handlebars.compile("{{sku}}\t{{qty}}\t{{name}}\n")

  constructor: (table) ->
    @products = []

    @$table = table
    @textarea = @$table.find('[data-hook="email_content"] textarea')
    @textarea.parent().slideDown() # un-hide textarea

    @collectProducts()
    @populateField()

  parseTableRow: (row) ->
    cells = row.children
    product =
      name: cells[0].innerHTML
      sku:  cells[1].innerHTML
      qty:  cells[2].innerHTML

    @products.push product

  collectProducts: (context) ->
    @$table.find('table.index tbody tr').each (index, el) =>
      @parseTableRow(el)

  populateField: ->
    order_text = ""
    for product in @products
      order_text += @template(product)
    
    @textarea.val order_text

