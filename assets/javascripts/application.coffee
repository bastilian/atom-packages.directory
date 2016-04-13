#= require lib/utilities
#= require collections/categories
#= require views/category-navigator-view

class AtomPackageAdmin
  bar: el('div', 'admin-bar')
  constructor: ->
    @render()

    @categories = new Categories()
    @categories.fetch().then (data) =>
      new CategoryNavigatorView(data, @)

  render: ->
    prepend(@bar, document.body)

@ready ->
  new AtomPackageAdmin()
