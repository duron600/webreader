//= require jquery
//= require underscore
//= require underscore.string
//= require backbone
//= require_self
//= require_tree .

window.Reader = {}
Reader.templates = {}
Reader.extend = (obj, mixin) -> obj[name] = method for name, method of mixin
Reader.include = (klass, mixin) -> extend klass.prototype, mixin
Reader.fontSize = 16
Reader.pageEm = 48
Reader.pageHeight = Reader.pageEm * Reader.fontSize

$ ->
  authToken = $('meta[name=csrf-token]').attr('content')
  $.ajaxSetup
    data:
      authenticity_token: authToken
  router = new Reader.Router
  Backbone.history.start()
