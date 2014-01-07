class window.HandsomeLogo

  $logo: $('#logo')

  prepareMLetter: ->
    _this = @
    $m = _this.$logo.find(".m")

    $m.html('<canvas width="26" height="22"></canvas>')

  showLogo: ->
    console.log('Showing logo');
    $('#logo').show()

  constructor: ->
    #@prepareMLetter()
    @showLogo()


$(->
  window.handsomeLogo = new HandsomeLogo()
)