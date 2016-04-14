class @Model
  constructor: (data, collection) ->
    @collection = collection

    extend(@, data)

  url: ->
    @collection.modelUrl + '/' + @[@collection.identify_by]

  update: (updates) ->
    console.log updates
    return fetch @url(), { method: 'PUT', body: JSON.stringify(updates) }
              .then =>
                return @
