class Reader.PageBreak
  constructor: (chapter, book)->
    @_chapter = chapter
    @_book = book
    @_index = 0

  run: ->
    @_chapter.setPageIndex @_book.pageTotals()
    if @_chapter.hasContent()
      loop
        @prepareNewPage() if @needNewPage()
        @_page.addParagraph @currentParagraph().clone()
        if @isLastParagraph()
          @savePage @_page
          break

        if !@_page.isOverflow()
          @moveToNextParagraph()

  needNewPage: ->
    !@_page || @_page.isOverflow()

  prepareNewPage: ->
    previousPage = @_page
    offset = if previousPage then 0 - previousPage.gapHeight() else 0
    @_page = new Reader.Page(offset: offset, chapter: @_chapter, position: @_index)
    @_page.render()
    @savePage previousPage

  isLastParagraph: ->
    @_index is @_chapter.paragraphs().length - 1

  savePage: (page) ->
    if page
      @_book.addPage page
      page.setPageIndex @_book.pageTotals() - 1
      page.remove()

  moveToNextParagraph: ->
    @_index += 1

  currentParagraph: ->
    $(@_chapter.paragraphs()[@_index])
