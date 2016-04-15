#= require lodash/dist/lodash
#= require lib/utilities
#= require collections/categories
#= require views/category-navigator-view
#= require views/category-view

class AtomPackageAdmin
  bar: el('div', 'atom-package-admin')
  routes: [
    {
     route: '/category'
     view: CategoryView
    }
  ]

  constructor: ->
    @render()
    @fetchCategories()

  setMainView: ->
    route = _.find @routes, (route) ->
      return _.startsWith(location.pathname, route.route)

    if route
      @mainView = new route.view(@)

  fetchCategories: ->
    @categories = new Categories()
    @categories.fetch().then (data) =>
      @setMainView()

  render: ->
    prepend(@bar, document.body)

@ready ->
  new AtomPackageAdmin()
