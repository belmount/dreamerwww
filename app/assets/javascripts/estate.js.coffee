$(document).ready ->
  ### map manipulate ###
  raw_markers = eval($('#data_holder').data('json') )
  
  handler = Gmaps.build('Google')
  handler.buildMap 
    provider: 
      zoom: 15, 
      center: new google.maps.LatLng(30.593,114.305)
    internal: 
      id: 'map', 
    ->
      gmaps_markers = handler.addMarkers raw_markers
      handler.bounds.extendWith gmaps_markers
      gmaps_markers[0].panTo() 

  ### handles the carousel thumbnails ###
  $('[id^=carousel-selector-]').click ->
    id_selector = $(this).attr("id")
    id = id_selector.substr id_selector.length -1
    id = parseInt id
    $('#carousel-imgs').carousel id
    $('[id^=carousel-selector-]').removeClass 'selected'
    $(this).addClass 'selected'

  ### when the carousel slides, auto update ###
  $('#carousel-imgs').on 'click',  (e)->
    id = $('.item.active').data 'slide-number'
    id = parseInt id
    $('[id^=carousel-selector-]').removeClass 'selected'
    $('[id^=carousel-selector-'+id+']').addClass 'selected'