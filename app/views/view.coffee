module.exports = class View extends Backbone.View
  debug: on

  start_debugging: ->
    @on "#{@cid}:initialize", ->
      console.debug "Initialized #{@name}", @

    @on "#{@cid}:render", ->
      console.debug "Rendered #{@name}", @

    @on "#{@cid}:update", ->
      console.debug "Updated #{@name}", @

    @on "#{@cid}:destroy", ->
      console.debug "Destroyed #{@name}", @

  type: 'view'

  name: null

  auto_render: off

  rendered: no

  template: -> ''

  # jQuery Shortcuts
  html: (dom) ->
    @$el.html(dom)
    @trigger "#{@cid}:#{if @rendered then 'update' else 'render'}", @
    @$el

  append: (dom) ->
    @$el.append(dom)
    @trigger "#{@cid}:#{if @rendered then 'update' else 'render'}", @
    @$el

  prepend: (dom) ->
    @$el.prepend(dom)
    @trigger "#{@cid}:#{if @rendered then 'update' else 'render'}", @
    @$el

  after: (dom) ->
    @$el.after(dom)
    @trigger "#{@cid}:update", @
    @$el

  before: (dom) ->
    @$el.after(dom)
    @trigger "#{@cid}:update", @
    @$el

  css: (css) ->
    @$el.css(css)
    @trigger "#{@cid}:update", @
    @$el

  find: (selector) ->
    @$el.find(selector)

  delegate: (event, selector, handler) ->
    handler = selector if arguments.length is 2
    handler = (handler).bind @

    if arguments.length is 2
      @$el.on event, handler
    else
      @$el.on event, selector, handler

  # Use bootstrap method instead of initialize
  bootstrap: ->

  initialize: ->
    @debug = no if !location.href.match /localhost/
    @bootstrap()

    @name = @name or @constructor.name
    @start_debugging() if @debug is on
    @render() if @auto_render is on

    super()
    @refreshElements()
    @delegateEvents()

    @trigger "#{@cid}:initialize", @

  get_render_data: -> @model?.toJSON() or {}

  render: ->
    @trigger "#{@cid}:render:before", @

    @$el.attr('data-cid', @cid)
    @html @template(@get_render_data())
    @rendered = yes

    @trigger "#{@cid}:render:after", @
    @trigger "render:after"
    @ready()
    @

  ready: -> #do something w/ dom

  destroy: (keepDOM = no) ->
    @trigger "#{@cid}:destroy:before", @

    if keepDOM then @dispose() else @remove()
    @model?.destroy()

    @trigger "#{@cid}:destroy:after", @
