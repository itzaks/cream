View = require './view'


class Transaction extends Backbone.Model
  defaults: tags: []
class Transactions extends Backbone.Collection
  model: Transaction
class TransactionView extends Backbone.View
  template: require 'templates/transaction'
  elements: view: '.transaction'
  events: view: 'click'

  render: ->
    @$el.html @template @model.toJSON()
    @

  view_click: (event)  ->
    @set_new_tags()

  set_new_tags: ->
    tags = prompt "Enter tag name", @model.get("tags").join ", "
    return unless tags or (tags?.length is 1 and tags[0] is "")
    @model.set "tags", tags.split ", "

module.exports =
class Index extends View
  className: 'page'
  template: require 'templates/index'
  elements: transactions: '.transactions'

  bootstrap: -> $.get '/transactions', (data, a, b, i = 0) =>
    total_amount = 8500
    for model in data
      model.id = i++ 
      amount = parseInt (model.amount.replace(" ", "").replace(" ", "").replace(" ", "")), 10
      model.total_amount = total_amount + amount
    @collection = new Transactions data
    @generate_transaction_views()
    @render()

  generate_transaction_views: ->
    {models} = @collection
    @transaction_views = for model in models
      new TransactionView {model} 

  render: ->
    console.log "render", @transaction_views
    super()
    return @ unless @transaction_views
    @$transactions.html (v.render().el for v in @transaction_views)
    @

  ready: ->
    @refreshElements()
    for el in @$('.transaction-date')
      $el = $(el)
      $el.text moment($el.text(), "YYMMDD").fromNow()
