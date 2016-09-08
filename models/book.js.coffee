class Reader.Book extends Backbone.Model

  initialize: ->
    @_pages = []
    @_progress = new Reader.Progress(this)

  pages: ->
    @_pages

  url: ->
    "books/#{@id}/read"

  download: ->
    @trigger 'download:start'
    @fetch
      success: =>
        @breakPage()
        @_progress.fetch =>
          @locateCurrentPage()
          @trigger 'download:success'
      error: =>
        @trigger 'download:error'

  locateCurrentPage: ->
    if @get 'page'
      @_currentPageIndex = @get('page') - 1
    else
      @_currentPageIndex = @lastReadPageIndex()

  lastReadPageIndex: ->
    return 0 if @_progress.isUnsaved()
    page = _.find @_pages, (page)=>
      page.chapter().id == @_progress.chapter() && page.position() == @_progress.offset()
    page.pageIndex()

  breakPage: ->
    @eachChapter (chapter) =>
      new Reader.PageBreak(chapter, this).run()

  chapters: ->
    @_chapters ||= (new Reader.Chapter(rawJson) for rawJson in @get('chapters'))

  eachChapter: (fn) ->
    for chapter in @chapters()
      fn chapter
      chapter.eachSubChapter fn

  currentPage: ->
    @_pages[@_currentPageIndex]

  nextPage: ->
    @_pages[@_currentPageIndex + 1]

  previousPage: ->
    @_pages[@_currentPageIndex - 1]

  saveProgress: ->
    @_progress.save
      chapter: @currentPage().chapter().id,
      offset: @currentPage().position(),
      timestamp: new Date
      percentage: @currentPage().pageNumber() / @pageTotals() * 100

  pageTotals: ->
    @_pages.length

  addPage: (page) ->
    @_pages.push page

  currentPageIndex: ->
    @_currentPageIndex

  isBeginning: ->
    @_currentPageIndex < 1

  isEnd: ->
    @_currentPageIndex > @pageTotals() - 2

  moveToPageIndex: (index)->
    @_currentPageIndex = index
    @saveProgress()
