#= require collection-select-view

class @CategoryView
  element: el('div', 'category-admin')
  form: el('form')
  subCategoryButton: el('span', 'octicon octicon-file-submodule')
  mergeButton: el('span', 'octicon octicon-git-merge')
  confirmButton: el('span', 'octicon octicon-check')
  cancelButton: el('span', 'octicon octicon-x')
  modeText: el('span')
  mode: null
  modes: ['merge', 'subcategory']

  constructor: (application) ->
    @categories = application.categories
    @categoryTitle = find('section#content h1')[0]
    @categorySelect = new CollectionSelectView(@categories)

    @render()
    @observe()

  observe: ->
    @categorySelect.on 'change', (event) =>
      addClass(@element, 'changed')

    observe @mergeButton, 'click', =>
      @modeText.textContent = "Merge category in: "
      @setMode('merge')

    observe @subCategoryButton, 'click', =>
      @modeText.textContent = "Sub-Category of: "
      @setMode('subcategory')

    observe @confirmButton, 'click', =>
      @save()

  save: ->
    other_category =  @categories.find(@categorySelect.value())

    if @mode == 'merge'
      update = { merge_id: other_category.id }

    if @mode == 'subcategory'
      update = { parent_category_id: other_category.id }

    if update
      @currentCategory().update(update).then (category) =>
        if @mode == 'subcategory'
          location.href = '/category/' + other_category.permalink
        else
          location.reload()


  setMode: (mode) ->
    removeClasses(@element, @modes.join(' '))

    if @mode == mode
      @mode = null
    else
      @mode = mode
      addClass(@element, mode)

  currentCategory: ->
    permalink = location.pathname.replace(/^\//, '').split('/')[1]
    category = @categories.find permalink: permalink

    category

  render: ->
    append(@mergeButton, @element)
    append(@subCategoryButton, @element)

    wrapper = el('div')
    append(@modeText, wrapper)
    append(@categorySelect.selectElm, wrapper)
    append(@confirmButton, wrapper)
    append(@cancelButton, wrapper)
    append(wrapper, @form)

    append(@form, @element)
    append(@element, @categoryTitle)
