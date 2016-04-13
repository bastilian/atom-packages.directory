
@extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

@el = (tag, css_class) ->
  el = document.createElement(tag)
  if css_class
    addClass(el, css_class)
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
