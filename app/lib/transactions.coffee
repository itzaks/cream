LocalStorage = require 'lib/localstorage'
clean_string = require 'lib/clean_string'

class Transaction extends Backbone.Model

get_clean_name = (model) -> clean_string(model.get('name'))

module.exports =
class Transactions extends Backbone.Collection
  model: Transaction
  tags: new LocalStorage("tags")
  get_tags: (model) ->
    @tags.get()?[get_clean_name(model)] or []
  get_tags_as_string: (model) ->
    @get_tags(model).join ", "
  get_all_tags: -> 
    _ret = []
    tags = @tags.get()
    _.chain(tags).toArray().flatten().uniq().value()

  set_from_string: (tags, model) ->
    name = get_clean_name(model)
    tags = tags.split ", "
    stored_tags = @tags.get() or {}
    stored_tags[name] ?= []
    stored_tags[name] = (tag for tag in tags when tag isnt '')
    @tags.set(stored_tags)