Reader.ScrollableMode =
  setTopPosition: ->
    top = (if @model.isBeginning() then 0 else @model.currentPageIndex() - 1) * Reader.pageHeight
    @$('#pages > li').css top: top

  clearPages: ->
    @$('#pages > li').remove()

  renderPages: ->
    @model.previousPage().render() unless @model.isBeginning()
    @model.currentPage().render()
    @model.nextPage().render() unless @model.isEnd()

  isAtTopEdge: ->
    @model.pageTotals() * $('#wrap').scrollTop() % @$el.height() is 0

  turnToNextPage: ->
    if @model.isEnd()
      @showTip '已经是最后一页'
      return
    if @isAtTopEdge()
      $('#wrap').animate scrollTop: @model.nextPage().content().position().top
    else
      $('#wrap').animate scrollTop: @model.currentPage().content().position().top
  
  turnToPreviousPage: ->
    if @model.isBeginning()
      @showTip '已经是第一页'
      return
    $('#wrap').animate scrollTop: @model.previousPage().content().position().top

  turnToPage: (page) ->
    scrollTo = (page - 1) * Reader.pageHeight
    if scrollTo is $('#wrap').scrollTop()
      $('#wrap').scroll()
    else
      $('#wrap').scrollTop scrollTo

  scrolledPageIndex: ->
    Math.ceil(@model.pageTotals() * $('#wrap').scrollTop() / @$el.height())

  needTurnPage: ->
    @$('#pages > li').length is 0 || @scrolledPageIndex() isnt @model.currentPageIndex()

  scroll: ->
    if @needTurnPage()
      @model.moveToPageIndex @scrolledPageIndex()
      @clearPages()
      @renderPages()
      @setTopPosition()
