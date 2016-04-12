#= require collections/categories

@extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

class AtomPackageAdmin
  constructor: ->
    @categories = new Categories()
    @categories.fetch().then (data) ->
      console.log data


new AtomPackageAdmin()
