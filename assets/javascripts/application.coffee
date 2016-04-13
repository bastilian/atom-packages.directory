#= require lib/utilities
#= require collections/categories
#= require views/category-navigator-view

class AtomPackageAdmin
  bar: el('div', 'atom-package-admin')

  constructor: ->
    @render()
    @fetchCategories()

  fetchCategories: ->
    @categories = new Categories()
    @categories.fetch().then (data) =>
      @categoryNavigator = new CategoryNavigatorView(data, @)

  render: ->
    prepend(@bar, document.body)

@ready ->
  new AtomPackageAdmin()
