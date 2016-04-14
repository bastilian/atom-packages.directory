#= require fetch
#= require lib/model
#= require lodash-inflection

class @Collection
  data: []
  model: Model
  identify_by: 'permalink'

  constructor: ->
    @modelUrl = '/' + _.singularize @url.replace(/^\//, '')

    console.log @

  parseData: (json) ->
    json.forEach (model) =>
      @data.push new @model(model, @)

    @data

  findById: (id) ->
    return _.find @data, (model) ->
      return model.id == id

  find: (query) ->
    if _.isString query
      return @findById(query)

    if _.isObject query
      key = _.findKey @data, query

      return @data[key]

    return false

  fetch: ->
    return fetch(@url)
      .then (response) ->
        response.json()
      .then (json) =>
        @parseData(json)
      .then (data) ->
        data
