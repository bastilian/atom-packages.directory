#= require collection-select-view

class @CategoryNavigatorView
  element: el('div', 'category-navigator')

  constructor: (application) ->
    @application = application
    @categories = @application.categories
    @categorySelect = new CollectionSelectView(@categories)

    @render()


  observe: ->
    @categorySelect.on 'change', (event) =>
      id = @categorySelect.value()
      category = @categories.find(id)
      location.href = '/category/' + category.permalink

  render: ->
    @element.textContent = 'Go to: '
    append(@categorySelect.selectElm, @element)
    append(@element, @application.bar)

    @observe()
