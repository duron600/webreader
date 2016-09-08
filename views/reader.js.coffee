class Reader.ReaderView extends Backbone.View
  el: '#wrap'
  template: _.template Reader.templates.reader

  events:
    'click #panel .back': ->
      window.location = '/bookstore'

    'click #panel .fullscreen': 'fullscreen'
    'click #panel .help': ->
      @$('.note').toggle()
    'click .note-icon': 'showNote'
    'click': 'hideNote'
    'click #panel .mode': 'switchMode'
    'scroll': ->
      clearTimeout @scrollTimeout
      @scrollTimeout = setTimeout =>
        @_bookView.scroll()
      , 100

  initialize: ->
    @$el.html @template()
    @_bookView = new Reader.BookView(model: @model)
    window.bookView = @_bookView
    @$('#panel .fullscreen').hide() unless @fullscreenable()

  turnToPage: (page) ->
    @_bookView.turnToPage page

  fullscreen: ->
    document.documentElement[@fullscreenFunctionName()]()

  fullscreenable: ->
    @fullscreenFunctionName() isnt ''

  fullscreenFunctionName: ->
    docElement = document.documentElement
    for name in ['requestFullscreen', 'mozRequestFullscreen', 'webkitRequestFullscreen']
      if docElement[name]
        return name
    ''

  showNote: (event)->
    new Reader.InlineNote($(event.target)).show()
    false

  hideNote: ->
    $('.inline-note').fadeOut()

  switchMode: ->
    @$('#reader').toggleClass 'scrollable'
    if @isScrollableMode()
      $('#panel .mode').addClass 'scroll'
      @$('#reader').height Reader.pageHeight * @model.pageTotals()
      @_bookView.switchMode Reader.ScrollableMode
    else
      $('#panel .mode').removeClass 'scroll'
      @$('#reader').removeAttr('style')
      @_bookView.switchMode Reader.SimpleMode

  isScrollableMode: ->
    !!@$('#reader.scrollable').length
