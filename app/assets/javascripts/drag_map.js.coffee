enableDrag = (drag, markers)->
  if drag
    pos_marker = markers[0].serviceObject
    google.maps.event.addListener pos_marker, 'dragend', ->
            $('#from_lat').val pos_marker.position.lat()
            $('#from_lng').val pos_marker.position.lng()

init_func = (drag) ->
    if drag
      gmaps_markers = handler.addMarkers raw_markers, draggable: true
    else
      gmaps_markers = handler.addMarkers raw_markers

    gmaps_markers[0].panTo()
    createSidebar()
    enableDrag(gmaps_markers)
    handler.bounds.extendWith gmaps_markers