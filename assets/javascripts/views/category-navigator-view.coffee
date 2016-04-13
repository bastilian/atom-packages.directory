class @CategoryNavigatorView
  el: el('div', 'category-navigator')
  select: el('select')
  constructor: (categories, application) ->
    @categories = categories
    @application = application

    @render()

  categoryElement: (category) ->
    elm = el('option')
    elm.textContent = category.name

  render: ->
    @el.textContent = 'Go to: '
    @categories.forEach (category) =>
      append(@categoryElement(category), @select)

    append(@select, @el)
    append(@el, @application.bar)
