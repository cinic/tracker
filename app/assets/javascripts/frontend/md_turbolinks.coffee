Turbolinks.ProgressBar.enable()
document.addEventListener 'page:change', ->
  componentHandler.upgradeDom()
#document.addEventListener 'turbolinks:render', ->
#  componentHandler.upgradeDom()
document.addEventListener 'page:restore', ->
  componentHandler.upgradeDom()
