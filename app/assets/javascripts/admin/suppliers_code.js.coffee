# http://ivaynberg.github.com/select2/#documentation
jQuery ->
  new_row_template = Handlebars.compile($('#suppliers-new-product-row').html())
  input_field = $("<input type='number' value='' />")

  # Hooks used for changing existing records quantities
  $(document)
    .on 'click', '#suppliers_report table.index td.quantity', ->
      if ($(this).children('input').size() == 0)
        field = input_field.clone()
        field.val($(this).html())
        $(this).html field
        $(this).find('input').focus()
    .on 'blur', '#suppliers_report table.index td.quantity input', (el) ->
      $(this).parent().html $(this).val()

  # Because we need to process returned data we use a custom hook
  # Since we only use it here it is not made as a jQuery plugin ($.fn.variantAutocomplete)
  $("#suppliers_report .variant_autocomplete").select2
    placeholder: "Select a variant"
    minimumInputLength: 4
    allowClear: true
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
        product:
          sku: product.sku
          name: product.name
      product.name

  # Handle clicks on "Add button"
  # Add variant name, sku and qty to the table
  $('#suppliers_report [data-hook="add_button"]').on "click", ->
    $fieldset = $(this).parents("fieldset")
    product = $fieldset.data("product")

    # If no product was chosen from dropdown sku will not exist and we shouldn't add anything
    return false unless product

    product.qty = $fieldset.find('[data-hook="add_quantity"] input').val()

    # Hide email content if visible
    textarea = $(this).parents('.supplier_products_table').find('[data-hook="email_content"]')
    textarea.val('')
    textarea.slideUp() if textarea.is(':visible')

    $table = $(this).parents('.supplier_products_table').find('tbody')
    $table.append new_row_template(product)

    # Reset fields
    $fieldset.find('input[type="hidden"].variant_autocomplete')
      .data('product', null)
      .select2('data', null)

    return false

  $('#suppliers_report [data-hook="send_button"]').on "click", ->
    window.report = new SuppliersEmailReport $(this).parents('.supplier_products_table')
    return false

  $('#suppliers_report [data-hook="send_email_button"]').on "click", ->
    content = $(this).siblings('textarea').val()
    encoded_content = encodeURIComponent(content)

    email = $(this).siblings('[data-email]').data('email')
    composeGmail(email, 'Naročilo', encoded_content)
    return false


# Function we use to compose email with javascript call in a popup window
composeGmail = (to, subject, body) ->
  window.open('https://mail.google.com/mail?view=cm&tf=0&su=' + subject + '&to=' + to + '&body=' + body ,'gmailForm','scrollbars=yes,width=680,height=510,top=175,left=75,status=no,resizable=yes')
  return false


# Parse the table of variants, get values and put them in a textarea
# Also handles encoding/decoding of HTML/plaintext
class SuppliersEmailReport

  constructor: (table) ->
    @products = []

    @$table = table
    @$textarea = @$table.find('[data-hook="email_content"] textarea')
    @$textarea.parent().slideDown() if @$textarea.parent().is(':hidden')

    @template = Handlebars.compile(@$table.find('.supplier_email_template').html())

    @collectProducts()
    @populateField()

  parseTableRow: (row) ->
    cells = row.children
    product =
      name: $('<div/>').html(cells[0].innerHTML).text() # decode HTML to plaintext
      sku:  cells[1].innerHTML
      qty:  cells[2].innerHTML

    @products.push product

  collectProducts: (context) ->
    @$table.find('table.index tbody tr').each (index, el) =>
      @parseTableRow(el)

  populateField: ->
    @$textarea.val @template(products: @products)

