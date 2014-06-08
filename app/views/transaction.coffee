module.exports = 
class TransactionView extends Backbone.View
  template: require 'templates/transaction'
  elements: view: '.transaction'
  events: view: 'click'

  initialize: ->
    super()
    @listenTo @model, 'change', @render

  render: ->
    render_data = @model.toJSON()
    render_data.tags = @model.collection.get_tags(@model)
    @$el.html @template render_data
    @refreshElements()
    @delegateEvents()
    @

  view_click: (event)  ->
    @set_new_tags()

  set_new_tags: ->
    tags = prompt "Enter tag name", @model.collection.get_tags_as_string(@model)
    return unless tags?
    @model.collection.set_from_string tags, @model
    Backbone.Mediator.pub 'tags:change'
