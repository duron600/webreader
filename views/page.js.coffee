class Reader.PageView extends Backbone.View

  tagName: 'li'

  initialize: ->
    @_pageNumber = 0
    @$el.append("<div class='page'><div class='content' style='top: #{@offset()}px'></div></div><div class='page-number'></div>")
    @render()

  position: ->
    @options['position'] || 0

  chapter: ->
    @options['chapter']

  title: ->
    @chapter().title() || ''

  offset: ->
    @options['offset'] || 0

  render: ->
    @$('.inline-note').hide()
    $('#pages').append @$el

  addParagraph: (paragraph) ->
    $(paragraph).find('.inline-note').hide().before("<div class='note-icon'></div>")
    @$('.content').append paragraph

  isOverflow: ->
    @lastParagraphBottom() > @$el.height() - @offset()

  lastParagraphBottom: ->
    if @lastParagraphElement().length == 0
      return 0
    @lastParagraphElement().position().top + @lastParagraphElement().outerHeight(true)

  gapHeight: ->
    if @isOverflow() then @$el.height() - @lastParagraphElement().position().top - @offset() else 0

  lastParagraphElement: ->
    @$('.content > *:last')

  pageNumber: ->
    @_pageNumber

  setPageNumber: (pageNumber) ->
    @_pageNumber = pageNumber
    @$('.page-number').text "第 #{pageNumber} 页"
