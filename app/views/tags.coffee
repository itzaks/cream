module.exports = 
class Tags extends Backbone.View
  el: ".page-tags"
  initialize: ->
    super()
    styles = new LocalStorage 'styles'
    for class_name, style of styles.get()
      jss.set(class_name, style)