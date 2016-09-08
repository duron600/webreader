class Reader.Chapter extends Backbone.Model

  initialize: ->
    super arguments
    @_pageIndex = 0

  subChapters: ->
    @_subChapters ||= (new Reader.Chapter(rawJson) for rawJson in @get('subChapters'))

  title: ->
    @get 'title'

  content: ->
    @get 'content'

  paragraphs: ->
    @_paragraphs ||= $(@content())

  hasContent: ->
    !_.string.isBlank(@content())

  eachSubChapter: (fn) ->
    for chapter in @subChapters()
      fn chapter

  pageIndex: ->
    @_pageIndex

  setPageIndex: (index)->
    @_pageIndex = index
