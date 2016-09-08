class Reader.Router extends Backbone.Router
  routes:
    'books/:id': 'read'
    'books/:id/page/:page': 'read'

  read: (id, page)->
    if @_readerView
      @_readerView.turnToPage(page || 1)
    else
      book = new Reader.Book(id: id, page: page)
      @_readerView = new Reader.ReaderView(model: book, page: page)
