Reader.SimpleMode =

  turnToNextPage: ->
    if @model.isEnd()
      @showTip '已经是最后一页'
      return
    window.location = "reader#books/#{@model.id}/page/#{@model.currentPageIndex() + 2}"
  
  turnToPreviousPage: ->
    if @model.isBeginning()
      @showTip '已经是第一页'
      return
    window.location = "reader#books/#{@model.id}/page/#{@model.currentPageIndex()}"

  turnToPage: (page) ->
    @model.currentPage().remove()
    @model.moveToPageIndex page - 1
    @model.currentPage().render()
    @$('#pages > li').css top: 0
    @updateTitle()

  updateTitle: ->
    @$('#header span').text @model.currentPage().title()

  scroll: ->
    # just an empty interface, do nothing.
