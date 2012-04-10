# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


window.bindHoverEfects = -> 
  $('.movie').hover(->
      $('.over', this).stop(true,true).fadeIn('fast')
    ,->
      $('.over', this).stop(true,true).fadeOut('fast')
    )

$ ->
  $('.carousel').carousel()
  $('a[rel=tooltip]').tooltip({
    placement: 'bottom'
  })

  $('li[rel=tooltip]').tooltip({
    placement: 'left'
  })

  
  window.bindHoverEfects()
    
  $('select').chosen()
  
  $('select').change(->
    $('form').submit()
  )