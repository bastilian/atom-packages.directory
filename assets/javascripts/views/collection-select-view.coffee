class @CollectionSelectView
  constructor: (collection) ->
    @collection = collection
    @selectElm = el('select')

    append(el('option'), @selectElm)
    @render()

  value: ->
    @selectElm.options[@selectElm.selectedIndex].getAttribute('value')

  optionElement: (item) ->
    elm = el('option')
    elm.setAttribute 'value', item.id
    elm.textContent = item.name

    elm

  render: ->
    @collection.data.forEach (item) =>
      append(@optionElement(item), @selectElm)

  on: (eventName, callback)->
    observe @selectElm, eventName, callback
