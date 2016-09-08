class Reader.Progress extends Backbone.Events
  constructor: (book)->
    @_book = book
    @_key = "book:#{@_book.id}:progress"
    @_syncTimer = setInterval @sync, 10 * 1000
    @_oldPercentage = 0

  offset: ->
    @load().offset || 0

  chapter: ->
    @load().chapter || 0

  timestamp: ->
    if @load().timestamp then new Date(@load().timestamp) else new Date

  percentage: ->
    @load().percentage || 0

  save: (values)->
    localStorage.setItem @_key, JSON.stringify(values)

  load: ->
    JSON.parse(localStorage.getItem @_key) || {}

  isUnsaved: ->
    @chapter() == 0

  isChanged: ->
    @_oldPercentage != @percentage()

  sync: =>
    #以防在没有翻页的情况下仍然不停地同步进度，造成太多请求。
    if @isChanged()
      @_oldPercentage = @percentage()
      $.ajax 
        url: "progress/#{@_book.id}"
        type: 'put'
        data:
          chapter: @chapter()
          offset: @offset()
          timestamp: @timestamp()
          percentage: @percentage()

  fetch: (fn)->
    $.get "progress/#{@_book.id}", (data)=>
      if new Date(data.timestamp) > @timestamp()
        delete data.app_book_id
        delete data.id
        @save data
      fn.call()
