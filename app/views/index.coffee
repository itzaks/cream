View = require './view'

class Transactions extends Backbone.Collection

module.exports =
class Index extends View
  className: 'page'
  template: require 'templates/index'
  bootstrap: -> $.get '/transactions', (data) => 
    @collection = new Transactions data
    @render()

  getRenderData: ->
    return transactions: @collection?.toJSON()