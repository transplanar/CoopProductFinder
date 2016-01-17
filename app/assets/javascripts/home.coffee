# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# REVIEW explain how this works (why serialize?)
jQuery ->
  # Ajax search on submit
  $('#card_search').submit( ->
    $.get(this.action, $(this).serialize(), null, 'script')
    false
  )
  # Ajax search on keyup
  $('#card_search input').keyup( ->
    $.get($("#card_search").attr("action"), $("#card_search").serialize(), null, 'script')
    false
  )
