$ -> 
  stopEvent = ( e ) ->
    e = e || window.event;
    if e
      if e.preventDefault() then e.preventDefault() else (e.returnValue = false)

  $('#released_on').datepicker( changeYear: true, yearRange: '1940:2000' )

  $('#like input').click (event) ->
    stopEvent(event)
    $.post(
      $('#like form').attr('action')
      (data) -> $('#like p').html(data).effect('highlight', color: '#fcd')
    )
