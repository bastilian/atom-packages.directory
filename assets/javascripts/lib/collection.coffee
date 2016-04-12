#= require fetch
#= require lib/model

class @Collection
  data: []
  model: Model

  constructor: ->

  parseData: (json) ->
    json.forEach (model) =>
      @data.push new @model(model)

  fetch: ->
    return fetch(@url)
      .then (response) ->
        response.json()
      .then (json) =>
        @parseData(json)
      .then =>
        @
