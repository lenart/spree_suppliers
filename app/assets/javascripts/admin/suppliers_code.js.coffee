jQuery ->
  # http://ivaynberg.github.com/select2/#documentation

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
