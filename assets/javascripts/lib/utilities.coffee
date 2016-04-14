@find = (selector) ->
  return document.querySelectorAll(selector)

@extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

@el = (tag, css_class) ->
  el = document.createElement(tag)
  if css_class
    css_class.split(' ').forEach (className) ->
      addClass(el, className)

  el

@prepend = (el, parent) ->
  parent.insertBefore(el, parent.firstChild)

@append = (el, parent) ->
  parent.appendChild el

@addClass = (el, className) ->
  if el.classList
    el.classList.add className
  else
    el.className += ' ' + className

@removeClass = (el, className) ->
  if el.classList
    el.classList.remove className
  else
    el.className = el.className.replace(
      new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'),
      ' ')

@removeClasses = (el, classNames) ->
  classNames.split(' ').forEach (className) ->
    removeClass(el, className)

@toggleClass = (el, className) ->
  if el.classList
    el.classList.toggle(className)
  else
    classes = el.className.split(' ')
    existingIndex = classes.indexOf(className)

    if existingIndex >= 0
      classes.splice(existingIndex, 1)
    else
      classes.push(className)

    el.className = classes.join(' ')

@empty = (el) ->
  while el.hasChildNodes()
    el.removeChild el.lastChild

@ready = (fn) ->
  if document.readyState != 'loading'
    fn()
  else
    document.addEventListener('DOMContentLoaded', fn)

@observe = (elm, eventName, callback) ->
  elm.addEventListener(eventName, callback)
