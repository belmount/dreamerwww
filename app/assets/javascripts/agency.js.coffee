$(document).ready ->
  raw_markers = eval($('#data_holder').data('json') )
  need_last_flag = true if $('#data_holder').data('last_flag')?

  createSidebarLi = (agency_json, last_flag = false) ->
    if last_flag
      "<li><a><span class='glyphicon glyphicon-flag'></span>#{agency_json.marker_title}<\/a></li>"
    else
      "<li><a>#{agency_json.marker_title}<\/a></li>"

  bindLiToMarker = (li, marker) ->
    li.click -> 
      marker.panTo()
      google.maps.event.trigger marker.getServiceObject(), 'click'

  createSidebar = (markers)->
    for mark, i in raw_markers
      if need_last_flag?
        li = $(createSidebarLi(mark, i is raw_markers.length - 1))
      else
        li = $(createSidebarLi(mark))
      li.appendTo $('#markers_list')
      bindLiToMarker li, markers[i]

  
  zoom_level = 3

  ###
  map drag function
  ###
  draggable = $('#data_holder').data('drag')
  if draggable
    drag_script = $('#data_holder').data('dragpath') 
    $.getScript(drag_script) #will override init_map function
    zoom_level = 15
  else
    init_map = -> 
      gmaps_markers = handler.addMarkers raw_markers
      handler.bounds.extendWith gmaps_markers 
      handler.fitMapToBounds()
      createSidebar(gmaps_markers)


  handler = Gmaps.build('Google')
  handler.buildMap 
    provider: 
      zoom: zoom_level, 
      center: new google.maps.LatLng(30.593,114.305)
    internal: 
      id: 'map', 
    init_map
      

  another_js =  $('#data_holder').data('init_js')
  $.getScript(another_js) if another_js

