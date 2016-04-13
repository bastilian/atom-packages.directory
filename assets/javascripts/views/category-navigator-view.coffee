class @CategoryNavigatorView
  el: el('div', 'category-navigator')
  select: el('select')
  constructor: (categories, application) ->
    @categories = categories
    @application = application

    observe @select, 'change', (event) ->
      select_elm = event.target
      location.href = select_elm.options[select_elm.selectedIndex]
                                  .getAttribute('data-url')

    @render()

  categoryElement: (category) ->
    elm = el('option')
    elm.setAttribute 'value', category.id
    elm.setAttribute 'data-url', '/category/' + category.permalink
    elm.textContent = category.name

    elm

  render: ->
    @el.textContent = 'Go to: '
    @categories.forEach (category) =>
      append(@categoryElement(category), @select)

    append(@select, @el)
    append(@el, @application.bar)
