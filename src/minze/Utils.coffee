#Workaround for using requestAnimationFrame in different browsers,
#see Paul Irish's Blog: http://paulirish.com/2011/requestanimationframe-for-smart-animating/
requestAnimFrame =
  window.requestAnimationFrame       ||
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback) ->
    window.setTimeout callback, 1000 / 60

# in IE the console host object is not exposed without the developer tools
# so in IE some code may break and do nothing at all...
# this snippet serves as a workaround
window.console = {log: ->} unless window.console