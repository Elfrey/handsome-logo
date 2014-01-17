class window.HandsomeLogo

  SCREEN_WIDTH: window.innerWidth
  SCREEN_HEIGHT: window.innerHeight
  camera: undefined
  controls: undefined
  keyboard: undefined
  renderer: undefined
  scene: undefined
  textMesh: undefined
  logoMesh: undefined #logo as M letter
  logoGroup: undefined
  spotlight: undefined
  rotObjectMatrix: undefined
  clock: new THREE.Clock()
  delta: ->
    @clock.getDelta()


  rotateAroundObjectAxis: (object, axis = [0,1,0], rotateAngle = Math.PI / 2 * @delta()) ->
    rotationMatrix = new THREE.Matrix4().identity()
    object.rotateOnAxis( new THREE.Vector3(axis[0],axis[1],axis[2]), rotateAngle);

  createLightProjector: ->
    _this = this
    _this.textMesh.castShadow = true
    _this.logoMesh.castShadow = true
    _this.logoGroup.castShadow = true

    # must enable shadows on the renderer
    _this.renderer.shadowMapEnabled = true

    # "shadow cameras" show the light source and direction

    # spotlight #1 -- yellow, dark shadow
    spotlight = new THREE.SpotLight(0xffffff)
    spotlight.position.set -60, 100, -30
    spotlight.shadowCameraVisible = true
    spotlight.shadowDarkness = 0.95
    spotlight.intensity = 2

    # must enable shadow casting ability for the light
    spotlight.castShadow = true
    _this.scene.add spotlight
    spotlight.target = _this.logoMesh
    _this.spotlight = spotlight

    # create "light-ball" meshes
    sphereGeometry = new THREE.SphereGeometry(10, 16, 8)
    darkMaterial = new THREE.MeshBasicMaterial(color: 0x000000)
    wireframeMaterial = new THREE.MeshBasicMaterial(
      color: 0xffff00
      wireframe: true
      transparent: true
    )
    shape = THREE.SceneUtils.createMultiMaterialObject(sphereGeometry, [darkMaterial, wireframeMaterial])
    shape.position = spotlight.position
    _this.scene.add shape

    # floor: mesh to receive shadows
    floorTexture = new THREE.ImageUtils.loadTexture("images/checkerboard.jpg")
    floorTexture.wrapS = floorTexture.wrapT = THREE.RepeatWrapping
    floorTexture.repeat.set 10, 10

    # Note the change to Lambert material.
    floorMaterial = new THREE.MeshLambertMaterial(
      map: floorTexture
      side: THREE.DoubleSide
    )
    floorGeometry = new THREE.PlaneGeometry(1000, 1000, 100, 100)
    floor = new THREE.Mesh(floorGeometry, floorMaterial)
    floor.position.y = -0.5
    floor.rotation.x = Math.PI / 2

    # Note the mesh is flagged to receive shadows
    floor.receiveShadow = true
    _this.scene.add floor


    #position
    _this.logoGroup.position.set(0,50,0)
    _this.spotlight.position.set(10,0,100)




  createControl: ->
    _this = @
    $controlBlock = $("<div></div>", {
      "id": "logo-control"
      "class": "logo-control"
    })
    $controlBlockInner = $("<div></div>",
      "class" : "logo-control-inner"
    )
    $toggleButton = $("<button></button>",
      "class" : "logo-control-toggle-button btn"
      "text" : "Toggle"
    ).on("click",->
      $controlBlockInner.stop().slideToggle()
    ).appendTo($controlBlock)

    $controlBlockInner.appendTo($controlBlock)
    controlsList = [
      {
        "title": "Scale X",
        "optionName": "scale-x",
        "optionSelector": "scale",
        "optionAxis": "x",
        "value" : "0.5"
      },
      {
        "title": "Scale Y",
        "optionName": "scale-y",
        "optionSelector": "scale",
        "optionAxis": "y",
        "value" : "0.5"
      },
      {
        "title": "Scale Z",
        "optionName": "scale-z",
        "optionSelector": "scale",
        "optionAxis": "z",
        "value" : "0.3"
      },
      {
        "title" : "break"
      },
      {
        "title": "Position X",
        "optionName": "position-x",
        "optionSelector": "position",
        "optionAxis": "x",
        "value" : "0"
      },
      {
        "title": "Position Y",
        "optionName": "position-y",
        "optionSelector": "position",
        "optionAxis": "y",
        "value" : "0"
      },
      {
        "title": "Position Z",
        "optionName": "position-z",
        "optionSelector": "position",
        "optionAxis": "z",
        "value" : "0"
      }
    ]

    controlsListHtml = ""

    $.each(controlsList, ->
      item = @
      if item.title is "break"
        controlsListHtml += "<br>"
      else
        controlsListHtml += "<div><label>#{item.title} <span class=\"value\">#{item.value}</span></label> <div class=\"slider #{item.optionSelector}\"><input value=\"#{item.value}\" type=\"text\" data-type=\"#{item.optionAxis}\" name=\"#{item.optionName}\" class=\"#{item.optionSelector}\"/></div></div>"
    )

    $controlBlockInner.html(controlsListHtml)

    changeScale = (type = "", value = "")->
      scale = {
        x: $controlBlock.find("input[name='scale-x']").val()
        y: $controlBlock.find("input[name='scale-y']").val()
        z: $controlBlock.find("input[name='scale-z']").val()
      }
      if type != "" and value != ""
        scale[type] = value
      _this.logoGroup.scale.set(scale.x,scale.y,scale.z)

    changePosition = (type = "",value = "")->
      position = {
        x: $controlBlock.find("input[name='position-x']").val()
        y: $controlBlock.find("input[name='position-y']").val()
        z: $controlBlock.find("input[name='position-z']").val()
      }
      if type != "" and value != ""
        position[type] = value
      _this.logoGroup.position.set(position.x,position.y,position.z)

    $controlBlock.find(".scale.slider").each(->
      value = $(@).find("input").val()
      $(@).slider(
        min: 0
        max: 2
        value: value
        step: 0.1
        slide: (event,ui) ->
          $label = $(@).prev()
          $input = $(@).find("input")
          $input.val(ui.value)
          $label.find(".value").text(ui.value)
          changeScale($input.data("type"),ui.value)
      )
    )

    $controlBlock.find(".position.slider").each(->
      value = $(@).find("input").val()
      $(@).slider(
        min: -100
        max: 200
        value: value
        step: 1
        slide: (event,ui) ->
          $label = $(@).prev()
          $input = $(@).find("input")
          $input.val(ui.value)
          $label.find(".value").text(ui.value)
          changePosition($input.data("type"),ui.value)

      )
    )

#    changeScale()
#    changePosition()
    $controlBlock.appendTo($("body"))
  #end createControl

  groupMeshes: ->
    _this = this
    _this.logoGroup = new THREE.Object3D()
    _this.logoGroup.add(_this.textMesh)
    _this.logoGroup.add(_this.logoMesh)
    _this.logoGroup.scale.set(0.5, 0.5, 0.3)
    _this.logoGroup.position.set(0, -20, 0)

    _this.scene.add(_this.logoGroup)

  renderAxes: ->
    axes = new THREE.AxisHelper(100);
    @scene.add(axes);
  #end renderAxes

  renderScene: ->
    _this = this
    _this.prepareScene()

    # RENDERER
    if Detector.webgl
      _this.renderer = new THREE.WebGLRenderer(antialias: true)
    else
      _this.renderer = new THREE.CanvasRenderer()
    _this.renderer.setSize _this.SCREEN_WIDTH, _this.SCREEN_HEIGHT
    container = document.getElementById("ThreeJS")
    container.appendChild(_this.renderer.domElement)

    # EVENTS
    THREEx.WindowResize(_this.renderer, _this.camera)
    THREEx.FullScreen.bindKey(charCode: "m".charCodeAt(0))

    # CONTROLS
    _this.controls = new THREE.OrbitControls(_this.camera, _this.renderer.domElement)

    # LIGHT
    light = new THREE.PointLight(0x3a87ad)
    light.position.set 0, 250, 0
    _this.scene.add light

    # SKYBOX/FOG
    skyBoxGeometry = new THREE.CubeGeometry(10000, 10000, 10000)
    skyBoxMaterial = new THREE.MeshBasicMaterial(
      color: 0x9999ff
      side: THREE.BackSide
    )
    skyBox = new THREE.Mesh(skyBoxGeometry, skyBoxMaterial)

    _this.renderAxes()
    _this.renderLogo()
    _this.renderText()
    _this.groupMeshes()

    _this.scene.add(skyBox);
    _this.scene.fog = new THREE.FogExp2(0x9999ff, 0.00025)

    render = ->
      _this.renderer.render(_this.scene, _this.camera)

    update = ->
      _this.keyboard.pressed("z")
      _this.controls.update()


    animate = ->
      requestAnimationFrame animate
      render()
      update()

    animate()
  #end renderScene

  prepareScene: ->
    _this = this

    _this.scene = new THREE.Scene()

    VIEW_ANGLE = 45
    ASPECT = _this.SCREEN_WIDTH / _this.SCREEN_HEIGHT
    NEAR = 0.1
    FAR = 20000
    _this.camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
    _this.scene.add(_this.camera)
    _this.camera.position.set(0, 150, 400)
    _this.camera.lookAt(_this.scene.position)
    _this.keyboard = new THREEx.KeyboardState()
  #end prepareScene

  renderLogo2: ->
    _this = this

    cubeMaterialArray = []

    # order to add materials: x+,x-,y+,y-,z+,z-
    cubeMaterialArray.push new THREE.MeshBasicMaterial(color: 0xff3333)
    cubeMaterialArray.push new THREE.MeshBasicMaterial(color: 0xff8800)
    cubeMaterialArray.push new THREE.MeshBasicMaterial(color: 0xffff33)
    cubeMaterialArray.push new THREE.MeshBasicMaterial(color: 0x33ff33)
    cubeMaterialArray.push new THREE.MeshBasicMaterial(color: 0x3333ff)
    cubeMaterialArray.push new THREE.MeshBasicMaterial(color: 0x8833ff)
    cubeMaterials = new THREE.MeshFaceMaterial(cubeMaterialArray)

    # Cube parameters: width (x), height (y), depth (z),
    #        (optional) segments along x, segments along y, segments along z
    cubeGeometry = new THREE.CubeGeometry(100, 100, 60, 1, 1, 1)

    # using THREE.MeshFaceMaterial() in the constructor below
    #   causes the mesh to use the materials stored in the geometry
    cubeMesh = new THREE.Mesh(cubeGeometry, cubeMaterials)
    cubeMesh.position.set 82, 50, 130
    _this.scene.add cubeMesh


    tmpGeom = new THREE.Geometry()

    tmpGeom.vertices.push(new THREE.Vector3(10, 10, 0))
    tmpGeom.vertices.push(new THREE.Vector3(45, 50, 0))
    tmpGeom.vertices.push(new THREE.Vector3(10, 90, 0))
    tmpGeom.faces.push(new THREE.Face3(0, 1, 2))

    tmpGeom.computeFaceNormals();

    mesh = new THREE.Mesh(tmpGeom, new THREE.MeshNormalMaterial());
    mesh.position.set(82, 50, 200)
    _this.scene.add(mesh);
  #end renderLogo2

  renderLogo: ->
    _this = this
    logoPoints = []

    logoPoints.push new THREE.Vector2(0, 0)
    logoPoints.push new THREE.Vector2(49, 38)
    logoPoints.push new THREE.Vector2(98, 0)
    logoPoints.push new THREE.Vector2(98, 89)
    logoPoints.push new THREE.Vector2(49, 50)
    logoPoints.push new THREE.Vector2(0, 89)


    logoShape = new THREE.Shape(logoPoints)
    extrusionSettings =
      amount: 60
      curveSegments: 3
      bevelThickness: 1
      bevelSize: 2
      bevelEnabled: false
      material: 0
      extrudeMaterial: 1

    logoGeometry = new THREE.ExtrudeGeometry(logoShape, extrusionSettings)
    materialFront = new THREE.MeshBasicMaterial(color: 0xffff00)
    materialSide = new THREE.MeshBasicMaterial(color: 0xff8800)
    materialArray = [materialFront, materialSide]
    logoMaterial = new THREE.MeshFaceMaterial(materialArray)
    logoMesh = new THREE.Mesh(logoGeometry, logoMaterial)
    #    logoMesh.position.set(82,50,100)
    #    _this.scene.add(logoMesh)


    #add inner part 1
    logoInnerPoints = []
    logoInnerPoints.push new THREE.Vector2(9, 16)
    logoInnerPoints.push new THREE.Vector2(43, 44)
    logoInnerPoints.push new THREE.Vector2(8, 73)

    logoInnerShape = new THREE.Shape(logoInnerPoints)
    logoInnerGeometry = new THREE.ExtrudeGeometry(logoInnerShape, extrusionSettings)


    logoInnerMesh = new THREE.Mesh(logoInnerGeometry, logoMaterial)

    #add inner part 2
    logoInnerPoints = []
    logoInnerPoints.push new THREE.Vector2(89, 16)
    logoInnerPoints.push new THREE.Vector2(89, 73)
    logoInnerPoints.push new THREE.Vector2(55, 44)

    logoInnerShape = new THREE.Shape(logoInnerPoints)
    logoInnerGeometry = new THREE.ExtrudeGeometry(logoInnerShape, extrusionSettings)


    logoInnerMesh2 = new THREE.Mesh(logoInnerGeometry, logoMaterial)
    #    logoInnerMesh.position.set(0,50,100)
    #    _this.scene.add(logoInnerMesh)


    #cutting off inner parts from logoMesh
    logoBSP = new ThreeBSP(logoMesh)
    innerBSP = new ThreeBSP(logoInnerMesh)
    innerBSP2 = new ThreeBSP(logoInnerMesh2)

    finalLogoMaterial = new THREE.MeshBasicMaterial(
      { color: 0x595959, vertexColors: THREE.VertexColors }
    )

    materialFront = new THREE.MeshBasicMaterial(color: 0x595959)
    materialSide = new THREE.MeshBasicMaterial(color: 0x333333)
    materialArray = [materialFront, materialSide]
    finalLogoMaterial = new THREE.MeshFaceMaterial(materialArray)

    newBSP = logoBSP.subtract(innerBSP).subtract(innerBSP2)
    newMesh = newBSP.toMesh(finalLogoMaterial)
    newMesh.scale.set(0.5, 0.5, 1)
    newMesh.position.set(48, 44, 100)

    _this.logoMesh = newMesh
    #_this.scene.add(newMesh)
  #end renderLogo

# add a wireframe to model
#    wireframeTexture = new THREE.MeshBasicMaterial(
#      color: 0x000000
#      wireframe: true
#      transparent: true
#    )
#    starMesh = new THREE.Mesh(starGeometry, wireframeTexture)
#    starMesh.position.set 0, 50, 0
#    _this.scene.add(starMesh)

  renderText: ->
    _this = this


    # add 3D text
    materialFront = new THREE.MeshBasicMaterial(color: 0x595959)
    materialSide = new THREE.MeshBasicMaterial(color: 0x333333)
    materialArray = [materialFront, materialSide]
    textGeom = new THREE.TextGeometry("HANDSO     E",
      size: 30
      height: 60
      curveSegments: 3
      font: "helvetiker"
      weight: "bold"
      style: "normal"
      bevelThickness: 1
      bevelSize: 2
      bevelEnabled: true
      material: 0
      extrudeMaterial: 1
    )
    textMaterial = new THREE.MeshFaceMaterial(materialArray)
    _this.textMesh = new THREE.Mesh(textGeom, textMaterial)
    textGeom.computeBoundingBox()
    textWidth = (textGeom.boundingBox.max.x - textGeom.boundingBox.min.x)
    _this.textMesh.position.set(-0.5 * textWidth, 50, 100)
    #_this.textMesh.rotation.x = -Math.PI / 4
    _this.textMesh.rotation.x = 0
    #_this.scene.add(_this.textMesh)
  #end renderText

  constructor: ->
    @renderScene()
    @createControl()
    @createLightProjector()
  #end constructor

$(->
  window.handsomeLogo = new HandsomeLogo()
)