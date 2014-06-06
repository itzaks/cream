module.exports =
class Lightbox extends Backbone.View
  className: "lightbox"
  elements:
    close: ".lightbox-close"
    confirm: ".lightbox-confirm"
  events:
    close: "click"
    confirm: "click"
  subscriptions:
    "keypress:escape": "close_click"

  initialize: ({@template, prompt}) ->
    super()
    if prompt?
      @$el.addClass "is-prompt"
      @confirm = prompt

  close_click: (event) ->
    event.preventDefault()
    @remove()

  confirm_click: (event) ->
    event.preventDefault()
    @confirm()
    @remove()

  confirm: -> #empty

  render: ->
    @$el.html @markup(@template)
    @$el.appendTo $("body")
    @delegateEvents()
    @post_render()

  post_render: ->
    @$("textarea")[0]?.select?()
