module.exports = 
class Storage
  constructor: (@key) ->
  set: (value) ->
    window.localStorage?.setItem(@key, JSON.stringify(value))
  get: ->
    item = window.localStorage?.getItem(@key)
    JSON.parse(item) if item