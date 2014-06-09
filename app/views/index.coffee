TransactionsCollection = require 'lib/transactions'
TransactionView = require './transaction'
LocalStorage = require 'lib/localstorage'
clean_string = require 'lib/clean_string'
View = require './view'
total_amount = 8500

module.exports =
class Index extends View
  className: 'page'
  auto_render: off
  template: require 'templates/index'
  elements: transactions: '.transactions'
  subscriptions: 'tags:change': 'render'
  views: tags: require './tags'

  bootstrap: -> 
    @fetch_transactions()

  fetch_transactions: ->
    $.get '/transactions', (data) =>
      {@transactions, @meta} = data
      @add_transactions()

  add_transactions: ->
    @add_total_to_model(model) for model in @transactions
    @collection = new TransactionsCollection @transactions
    @generate_transaction_views()
    @render()

  add_total_to_model: (model) ->
    amount = parseInt clean_string(model.amount), 10
    model.total_amount = total_amount - amount

  generate_transaction_views: ->
    {models} = @collection
    @transaction_views = for model in models
      new TransactionView {model} 

  render: ->
    super()
    @refreshElements()
    return @ unless @transaction_views
    @$transactions.html (v.render().el for v in @transaction_views)
    return this

  ready: ->
    for el in @$('.transaction-date')
      $el = $(el)
      $el.text moment($el.text(), "YYMMDD").fromNow()
