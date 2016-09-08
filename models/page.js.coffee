class Reader.Page

  constructor: (attrs)->
    @_pageIndex = 0
    @_position = attrs['position'] || 0
    @_offset = attrs['offset'] || 0
    @_chapter = attrs['chapter']
    @_content = $("""
      <li>
        <div class='page'>
          <div class='content' style='top: #{@_offset}px'></div>
        </div>
        <div class='page-number'></div>
      </li>
    """)

  position: ->
    @_position

  chapter: ->
    @_chapter

  title: ->
    @chapter().title() || ''

  addParagraph: (paragraph) ->
    $(paragraph).find('.inline-note').hide().before("<div class='note-icon'></div>")
    @_content.find('.content').append paragraph

  isOverflow: ->
    @lastParagraphBottom() > @_content.height() - @_offset

  lastParagraphBottom: ->
    if @isEmpty()
      return 0
    @lastParagraphElement().position().top + @lastParagraphElement().outerHeight(true)

  gapHeight: ->
    if @isOverflow() then @_content.height() - @lastParagraphElement().position().top - @_offset else 0

  lastParagraphElement: ->
    @_content.find('.content > *:last')

  isEmpty: ->
    @lastParagraphElement().length == 0

  pageIndex: ->
    @_pageIndex

  pageNumber: ->
    @pageIndex() + 1

  setPageIndex: (pageIndex) ->
    @_pageIndex = pageIndex
    @_content.find('.page-number').text "第 #{pageIndex + 1} 页"

  render: ->
    $('#pages').append @_content

  remove: ->
    @_content.remove()

  content: ->
    @_content
