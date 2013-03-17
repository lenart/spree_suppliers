jQuery ->

  extra_product_template = Handlebars.compile($('#extra-product').html())
  input_field = $("<input type='text' value='' />")

  $('[data-hook="add_product_supplier_index"]').click ->
    table = $(this).parent().siblings('table.index').children('tbody')
    table.append(extra_product_template({name: "blank", qty: 0}))
    return false

  $('table.index td.quantity').on 'click', ->
    if ($(this).children('input').size() == 0)
      field = input_field.clone()
      field.val($(this).html())
      $(this).html field

  $('.add_line_item_to_order').on 'click', ->
    # WIP
    console.log "Click caught by + ADD button"
    console.log $(this).closest('add_variant_id')
    $(this).closest('add_variant_id').find(".variant_autocomplete").variantAutocomplete();
    return false