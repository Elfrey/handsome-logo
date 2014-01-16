class window.HandsomeLogo

  SCREEN_WIDTH: window.innerWidth
  SCREEN_HEIGHT: window.innerHeight
  camera: {}
  controls: {}
  keyboard: {}
  renderer: {}
  scene: {}
  textMesh: {}

  renderAxes: ->
    axes = new THREE.AxisHelper(100);
    @scene.add( axes );

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
    THREEx.WindowResize( _this.renderer, _this.camera )
    THREEx.FullScreen.bindKey( charCode: "m".charCodeAt(0))

    # CONTROLS
    _this.controls = new THREE.OrbitControls(_this.camera, _this.renderer.domElement)

    # LIGHT
    light = new THREE.PointLight(0xffffff)
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
    _this.renderStar()
    _this.renderText()

    _this.scene.add(skyBox);
    _this.scene.fog = new THREE.FogExp2(0x9999ff, 0.00025)


  prepareScene: ->
    _this = this

    _this.scene = new THREE.Scene()

    VIEW_ANGLE = 45
    ASPECT = _this.SCREEN_WIDTH / _this.SCREEN_HEIGHT
    NEAR = 0.1
    FAR = 20000
    _this.camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
    _this.scene.add( _this.camera )
    _this.camera.position.set( 0, 150, 400 )
    _this.camera.lookAt( _this.scene.position )
    _this.keyboard = new THREEx.KeyboardState()


  renderStar: ->
    _this = this
    starPoints = []
#    starPoints.push new THREE.Vector2(0, 50)
#    starPoints.push new THREE.Vector2(10, 10)
#    starPoints.push new THREE.Vector2(40, 10)
#    starPoints.push new THREE.Vector2(20, -10)
#    starPoints.push new THREE.Vector2(30, -50)
#    starPoints.push new THREE.Vector2(0, -20)
#    starPoints.push new THREE.Vector2(-30, -50)
#    starPoints.push new THREE.Vector2(-20, -10)
#    starPoints.push new THREE.Vector2(-40, 10)
#    starPoints.push new THREE.Vector2(-10, 10)


#    starPoints.push new THREE.Vector2(50, 60)
#    starPoints.push new THREE.Vector2(50, 60)
#    starPoints.push new THREE.Vector2(0, 100)
#    starPoints.push new THREE.Vector2(100, 100)
#    starPoints.push new THREE.Vector2(50, 60)
#    starPoints.push new THREE.Vector2(0, 100)

    starPoints.push new THREE.Vector2(0,0)
    starPoints.push new THREE.Vector2(50,40)
    starPoints.push new THREE.Vector2(100,0)
    starPoints.push new THREE.Vector2(100,100)
    starPoints.push new THREE.Vector2(50,60)
    starPoints.push new THREE.Vector2(0,100)



    starShape = new THREE.Shape(starPoints)
    extrusionSettings =
      amount: 60
      curveSegments: 3
      bevelThickness: 1
      bevelSize: 2
      bevelEnabled: false
      material: 0
      extrudeMaterial: 1

    starGeometry = new THREE.ExtrudeGeometry(starShape, extrusionSettings)
    materialFront = new THREE.MeshBasicMaterial(color: 0xffff00)
    materialSide = new THREE.MeshBasicMaterial(color: 0xff8800)
    materialArray = [materialFront, materialSide]
    starMaterial = new THREE.MeshFaceMaterial(materialArray)
    star = new THREE.Mesh(starGeometry, starMaterial)
    star.position.set(82,50,100)
    _this.scene.add(star)


    #add inner part 1
    innerStarPoints = []
    innerStarPoints.push new THREE.Vector2(10,15)
    innerStarPoints.push new THREE.Vector2(45,55)
    innerStarPoints.push new THREE.Vector2(10,70)

    inner1Shape = new THREE.Shape(innerStarPoints)
    inner1Geometry = new THREE.ExtrudeGeometry(inner1Shape, extrusionSettings)
#    geometryCsg    = THREE.CSG.toCSG(inner1Geometry)

#    starCSG = THREE.CSG.toCSG(star)
#    starCSG.subtract(geometryCsg)

    materialFront2 = new THREE.MeshBasicMaterial(color: 0xff0000)
    materialSide2 = new THREE.MeshBasicMaterial(color: 0x00ff00)
    materialArray2 = [materialFront2, materialSide2]
    starMaterial2 = new THREE.MeshFaceMaterial(materialArray2)
    star2 = new THREE.Mesh(inner1Geometry, starMaterial2)
    star2.position.set(0,50,100)
    _this.scene.add(star2)


    # add a wireframe to model
    wireframeTexture = new THREE.MeshBasicMaterial(
      color: 0x000000
      wireframe: true
      transparent: true
    )
    star = new THREE.Mesh(starGeometry, wireframeTexture)
    star.position.set 0, 50, 0
    _this.scene.add(star)

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
    textWidth = textGeom.boundingBox.max.x - textGeom.boundingBox.min.x
    _this.textMesh.position.set( -0.5 * textWidth, 50, 100 )
    #_this.textMesh.rotation.x = -Math.PI / 4
    _this.textMesh.rotation.x = 0
    _this.scene.add(_this.textMesh)


    ###
      making M letter
    ###
    #Using wireframe materials to illustrate shape details.
    darkMaterial = new THREE.MeshBasicMaterial( { color: 0xffffcc } );
    wireframeMaterial = new THREE.MeshBasicMaterial( { color: 0x000000, wireframe: true, transparent: true } );
    multiMaterial = [ darkMaterial, wireframeMaterial ];

    shape = THREE.SceneUtils.createMultiMaterialObject(
    # radius of entire torus, diameter of tube (less than total radius),
    # segments around radius, segments around torus ("sides")
      new THREE.TorusGeometry( 25, 10, 8, 4 ),
      materialArray
    );
    shape.position.set(textWidth - 180, 50, 100);
    console.log(shape.position);
    _this.scene.add( shape );

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
  constructor: ->
    @renderScene()

$(->
  window.handsomeLogo = new HandsomeLogo()
)