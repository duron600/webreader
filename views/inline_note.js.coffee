class Reader.InlineNote
  constructor: (icon)->
    @_icon = icon
    @_text = @_icon.next()

  show: ->
    @_text.show()
    @locate()

  locate: ->
    if @iconIsOnTop()
      @moveToBottomOfIcon()
    else
      @moveToTopOfIcon()

    if @iconIsOnLeft()
      @closeToLeftSide()
    else if @iconIsOnRight()
      @closeToRightSide()
    else
      @alignCenter()

  iconIsOnTop: ->
    @_icon.position().top + @_icon.closest('.content').position().top < @_text.outerHeight()

  iconIsOnLeft: ->
    @iconHorizontalPosition() < @_text.outerWidth() / 2

  iconIsOnRight: ->
    $('.content').width() - @iconHorizontalPosition() < @_text.outerWidth() / 2

  iconHorizontalPosition: ->
    @_icon.position().left + @_icon.outerWidth() / 2

  moveToBottomOfIcon: ->
    @_text.css top: @_icon.position().top + @_icon.outerHeight()

  moveToTopOfIcon: ->
    shadowHeight = 5
    @_text.css top: @_icon.position().top - @_text.outerHeight() - shadowHeight

  closeToLeftSide: ->
    @_text.css left: 0

  closeToRightSide: ->
    shadowWidth = 5
    @_text.css left: $('.content').width() - @_text.outerWidth() - shadowWidth

  alignCenter: ->
    @_text.css left: @iconHorizontalPosition() - (@_text.outerWidth() / 2)
