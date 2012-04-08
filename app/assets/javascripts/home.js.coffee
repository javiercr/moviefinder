# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.carousel').carousel()
  $('a[rel=tooltip]').tooltip({
    placement: 'bottom'
  })

  $('li[rel=tooltip]').tooltip({
    placement: 'left'
  })
