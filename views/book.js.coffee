class Reader.BookView extends Backbone.View

  el: '#reader'
  template: _.template Reader.templates.book

  events:
    'click #page-turning li:first': -> @turnToPreviousPage()
    'click #page-turning li:last': -> @turnToNextPage()
    'click #header .toc-switch': -> @$('#toc').toggle()
    'click #toc a': -> @$('#toc').hide()

  initialize: ->
    $(window).keydown (event)=>
      keys = pageup: 33, pagedown: 34, left: 37, up: 38, right: 39, down: 40
      switch event.keyCode
        when keys.pageup, keys.up, keys.left
        then @turnToPreviousPage()

        when keys.pagedown, keys.down, keys.right
        then @turnToNextPage()
    @useMode Reader.SimpleMode
    @$el.html @template()
    @model.on
      'download:start': @loading
      'download:success': @render
      'download:error': @downloadError
      this
    @model.download()

  render: ->
    @$('.loading').remove()
    document.title = @model.get 'title'
    @turnToPage @currentPageNumber()
    @buildToc()

  switchMode: (mode) ->
    @useMode mode
    @$('#pages > li').remove()
    @turnToPage @currentPageNumber()

  useMode: (mode) ->
    Reader.extend this, mode

  loading: ->
    @$('#pages').append "<li class='loading'><div>内容载入中，请稍候…</div></li>"

  downloadError: ->

  showTip: (message, duration = 400)->
    $("<div id='tip'>#{message}</div>").hide().appendTo('#reader').fadeIn duration, ->
      setTimeout =>
        $(this).fadeOut duration, ->
          $(this).remove()
      , duration

  buildToc: ->
    @model.eachChapter (chapter) =>
      @$('#toc ol').append $("<li><a href='#books/#{@model.id}/page/#{chapter.pageIndex() + 1}'>#{chapter.title()}</a><span>#{chapter.pageIndex() + 1}</span></li>")

  currentPageNumber: ->
    @model.currentPageIndex() + 1
