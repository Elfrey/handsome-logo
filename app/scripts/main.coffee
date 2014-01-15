class window.HandsomeLogo

  $logo: $('#logo')
  $m: $('#logo').find(".m")

  fixLetters: ->
    _this = @
    $letters = _this.$logo.find('span')
    zIndex = $letters.size()

    $letters.each(->
      $(@).css(
        'z-index': zIndex--
      )
    )



  prepareMLetter: ->
    _this = @
    #_this.$m.html("<canvas width=\"#{_this.$m.width()}\" height=\"#{_this.$m.width()}\" id=\"m-canvas\"></canvas>")
    _this.$m.html('').addClass('font-icon-m')


  drawM: ->
    _this = @

    triangleOption = {
      angle: 90
      height: 13
      fill: 'transparent'
      left: 14
      stroke: 'black'
      strokeWidth: 1
      top: 0
      width: 13
    }

    canvas = new fabric.Element('m-canvas')
    leftTriangle = new fabric.Triangle($.extend(true, {}, triangleOption,{}))
    rightTriangle = new fabric.Triangle($.extend(true, {}, triangleOption,{
      angle: -90
      left: 23
    }))
    canvas.add(leftTriangle)
    canvas.add(rightTriangle)

  showLogo: ->
    _this = @
    _this.$logo.show()
    setTimeout(->
      _this.$logo.parents(".logo-container:first").addClass("origin")
    ,300)

  constructor: ->
    @prepareMLetter()
    #@drawM()
    @fixLetters();
    @showLogo()


$(->
  window.handsomeLogo = new HandsomeLogo()
)