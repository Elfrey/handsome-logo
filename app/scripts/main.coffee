class window.HandsomeLogo

  SCREEN_WIDTH: window.innerWidth
  SCREEN_HEIGHT: window.innerHeight
  camera: undefined
  controls: undefined
  keyboard: undefined
  light: undefined
  renderer: undefined
  scene: undefined
  textMesh: undefined
  logoMesh: undefined #logo as M letter
  logoGroup: undefined
  spotlight: undefined
  spolightPoint: undefined
  rotObjectMatrix: undefined
  clock: new THREE.Clock()
  delta: ->
    @clock.getDelta()


  renderPostament: ->
    self = this

    texture = new THREE.ImageUtils.loadTexture("images/textures/3.png")
    texture.wrapS = texture.wrapT = THREE.RepeatWrapping
    texture.repeat.set 10, 1
    material = new THREE.MeshPhongMaterial(map: texture)

    post1Geometry = new THREE.CubeGeometry(
      270,10,70
    )
    self.post1 = new THREE.Mesh(post1Geometry, material)
    self.post1.position.set(0, 93, 130)
    self.scene.add self.post1

    post2Geometry = new THREE.CubeGeometry(
      250,100,50
    )
    self.post2 = new THREE.Mesh(post2Geometry, material)
    self.post2.position.set(0, 38, 130)
    self.scene.add self.post2

    on
  #end renderPostament

  rotateAroundObjectAxis: (object, axis = [0,1,0], rotateAngle = Math.PI / 2 * @delta()) ->
    rotationMatrix = new THREE.Matrix4().identity()
    object.rotateOnAxis( new THREE.Vector3(axis[0],axis[1],axis[2]), rotateAngle);
  #end rotateAroundObjectAxis

  createLightProjector: ->
    self = this
    self.textMesh.castShadow = true
    self.logoMesh.castShadow = true
    self.logoGroup.castShadow = true

    # must enable shadows on the renderer
    self.renderer.shadowMapEnabled = true

    # "shadow cameras" show the light source and direction

    # spotlight #1 -- yellow, dark shadow
    spotlight = new THREE.SpotLight(0xffffff)
    spotlight.position.set -60, 100, -30
    spotlight.shadowCameraVisible = true
    spotlight.shadowDarkness = 0.95
    spotlight.intensity = 1
    spotlight.distance = 0
    spotlight.castShadow = true

    # must enable shadow casting ability for the light
    self.spotlight = spotlight
    self.scene.add spotlight

    # create "light-ball" meshes
    sphereGeometry = new THREE.SphereGeometry(10, 16, 8)
    darkMaterial = new THREE.MeshBasicMaterial(color: 0x000000)
    wireframeMaterial = new THREE.MeshBasicMaterial(
      color: 0xffff00
      wireframe: true
      transparent: true
    )
    self.spolightPoint = THREE.SceneUtils.createMultiMaterialObject(sphereGeometry, [darkMaterial, wireframeMaterial])
    self.spolightPoint.position = spotlight.position
    self.scene.add self.spolightPoint

    #position
    self.spotlight.position.set(0,0,250)

    #hidden target for spotlight
    self.lightTarget = new THREE.Object3D()
    self.lightTarget.position.set(150,450,-100)
    self.scene.add(self.lightTarget)
    self.spotlight.target = self.lightTarget


    #light cone - stupid idea
    ###self.cone = new THREE.Mesh(
      new THREE.CylinderGeometry(3, 75, 150),
      new THREE.MeshPhongMaterial({
        color: 0xffffff,
        ambient: 0xffffff,
        opacity: 0.33,
        transparent:true
      })
    )
    self.cone.position.set(14,85,250)
    self.cone.rotation.z = 625
    self.scene.add(self.cone)###


    #THREE.Projector() try. Have no idea how it should works.
#    projector = new THREE.Projector()
#    mouse_vector = new THREE.Vector3()
#    mouse = { x: 0, y: 0, z: 1 }
#    ray = new THREE.Raycaster( new THREE.Vector3(0,0,0), new THREE.Vector3(0,0,0) )
#    ray.intersectObject(self.logoMesh)
#    self.scene.add(ray)
#    self.scene.add(projector)
  #end createLightProjector

  renderPlanes: ->
    self = @
    # floor: mesh to receive shadows
    planeTexture = new THREE.ImageUtils.loadTexture("images/checkerboard.jpg")
    planeTexture.wrapS = planeTexture.wrapT = THREE.RepeatWrapping
    planeTexture.repeat.set 10, 10

    # Note the change to Lambert material.
    planeMaterial = new THREE.MeshLambertMaterial(
      map: planeTexture
      side: THREE.DoubleSide
    )
    planeGeometry = new THREE.PlaneGeometry(1000, 1000, 100, 100)

    planes = [
      {
        name: "top",
        position: [0,1000.5,0]
        rotation: {
          "key" : "x"
          "value": Math.PI / 2
        }
      }
      {
        name: "bottom",
        position: [0,-0.5,0]
        rotation: {
          "key" : "x"
          "value": Math.PI / 2
        }
      }
      {
        name: "left",
        position: [-500.5,500,0]
        rotation: {
          "key": "y"
          "value": Math.PI / 2
        }
      }
      {
        name: "rigth",
        position: [500.5,500,0]
        rotation: {
          "key": "y"
          "value": Math.PI / 2
        }
      }
      {
        name: "back",
        position: [0,500,-500.5]
        rotation: {
          "key": "z"
          "value": Math.PI / 2
        }
      }
    ]
    planeMeshes = {}
    planes = [] #TODO comment for boxws67=s-=-=-
    $.each(planes,->
      plane = @

      planeMeshes[plane.name] = new THREE.Mesh(planeGeometry, planeMaterial)
      planeMeshes[plane.name].position.set(plane.position[0],plane.position[1],plane.position[2])
      planeMeshes[plane.name].rotation[plane.rotation.key] = plane.rotation.value
      planeMeshes[plane.name].receiveShadow = true
      self.scene.add(planeMeshes[plane.name])
    )
    self.planeMeshes = planeMeshes
#    planeBottom = new THREE.Mesh(planeGeometry, planeMaterial)
#    planeBottom.position.x = -1000
#    planeBottom.rotation.y = Math.PI / 2
#    planeBottom.receiveShadow = true
#    self.scene.add planeBottom

  renderSkybox: ->
    self = @

    # SKYBOX/FOG
    ###skyBoxGeometry = new THREE.CubeGeometry(10000, 10000, 10000)
    skyBoxMaterial = new THREE.MeshBasicMaterial(
      color: 0x000000
      side: THREE.BackSide
    )
    skyBox = new THREE.Mesh(skyBoxGeometry, skyBoxMaterial)
    self.scene.add(skyBox);###

    skyBoxGeometry = new THREE.CubeGeometry(4000, 4000, 4000)
    skyBoxMaterial = new THREE.MeshBasicMaterial(
      color: 0x000000
      side: THREE.BackSide
    )
    self.skyBox = new THREE.Mesh(skyBoxGeometry, skyBoxMaterial)
    self.scene.add self.skyBox

  createControl: ->
    self = @
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
      self.logoGroup.scale.set(scale.x,scale.y,scale.z)

    changePosition = (type = "",value = "")->
      position = {
        x: $controlBlock.find("input[name='position-x']").val()
        y: $controlBlock.find("input[name='position-y']").val()
        z: $controlBlock.find("input[name='position-z']").val()
      }
      if type != "" and value != ""
        position[type] = value
      self.logoGroup.position.set(position.x,position.y,position.z)

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
    self = this
    self.logoGroup = new THREE.Object3D()
    self.logoGroup.add(self.textMesh)
    self.logoGroup.add(self.logoMesh)
    #self.logoGroup.scale.set(0.5, 0.5, 0.3)
    self.logoGroup.position.set(0,50,0)

    self.scene.add(self.logoGroup)
  #end groupMeshes

  renderLight: ->
    self = this

    # LIGHT
    #self.light = new THREE.PointLight(0x3a87ad)
    self.light = new THREE.HemisphereLight(0x808080,0xffffff)
    self.light.position.set 0, 250, 0
    #    self.light.position.x = -1000
    #    self.light.position.y = 0
    #    self.light.position.z = 1000
    self.light.intensity = 2.9
    self.light.distance = 10000
    self.scene.add self.light

  renderAxes: ->
    axes = new THREE.AxisHelper(100);
    @scene.add(axes);
  #end renderAxes

  renderScene: ->
    self = this
    self.prepareScene()

    # RENDERER
    if Detector.webgl
      self.renderer = new THREE.WebGLRenderer(antialias: true)
    else
      self.renderer = new THREE.CanvasRenderer()
    self.renderer.setSize self.SCREEN_WIDTH, self.SCREEN_HEIGHT
    container = document.getElementById("ThreeJS")
    container.appendChild(self.renderer.domElement)

    # EVENTS
    THREEx.WindowResize(self.renderer, self.camera)
    THREEx.FullScreen.bindKey(charCode: "m".charCodeAt(0))

    # CONTROLS
    self.controls = new THREE.OrbitControls(self.camera, self.renderer.domElement)


    self.renderPlanes()
    self.renderAxes()
    self.renderLogo()
    self.renderText()
    self.groupMeshes()

    self.scene.fog = new THREE.FogExp2(0x9999ff, 0.00025)
  #end renderScene

  init: ->
    self = @

    render = ->
      self.renderer.render(self.scene, self.camera)

    update = ->
      self.keyboard.pressed("z")
      self.controls.update()



    animate = ->
      requestAnimationFrame animate
      #self.spotlight.rotation.x += self.clock.getDelta()
      #self.animateProjector()
      if self.spotlight.target.position.x > 200
        self.modifier = -1
      if self.spotlight.target.position.x < -200
        self.modifier = 1
      x = self.spotlight.target.position.x + ( self.clock.getDelta() * self.modifier * 10)
      self.spotlight.target.position.setX(x)
      render()
      update()

    animate()
  #end init

  modifier: 1
  animateProjector: ->
    self = @
    if self.spotlight.target.position.x > 160
      self.modifier = -1
    if self.spotlight.target.position.x < 140
      self.modifier = 1
    x = self.spotlight.target.position.x + ( self.clock.getDelta() * self.modifier)
    self.spotlight.target.position.setX(x)

  prepareScene: ->
    self = this

    self.scene = new THREE.Scene()

    VIEW_ANGLE = 45
    ASPECT = self.SCREEN_WIDTH / self.SCREEN_HEIGHT
    NEAR = 0.1
    FAR = 20000
    self.camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
    self.scene.add(self.camera)
    self.camera.position.set(0, 150, 400)
    self.camera.lookAt(self.scene.position)
    self.keyboard = new THREEx.KeyboardState()
  #end prepareScene

  renderLogo2: ->
    self = this

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
    self.scene.add cubeMesh


    tmpGeom = new THREE.Geometry()

    tmpGeom.vertices.push(new THREE.Vector3(10, 10, 0))
    tmpGeom.vertices.push(new THREE.Vector3(45, 50, 0))
    tmpGeom.vertices.push(new THREE.Vector3(10, 90, 0))
    tmpGeom.faces.push(new THREE.Face3(0, 1, 2))

    tmpGeom.computeFaceNormals();

    mesh = new THREE.Mesh(tmpGeom, new THREE.MeshNormalMaterial());
    mesh.position.set(82, 50, 200)
    self.scene.add(mesh);
  #end renderLogo2

  renderLogo: ->
    self = this
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
    materialFront = new THREE.MeshPhongMaterial(color: 0xffff00)
    materialSide = new THREE.MeshBasicMaterial(color: 0xff8800)
    materialArray = [materialFront, materialSide]
    logoMaterial = new THREE.MeshFaceMaterial(materialArray)
    logoMesh = new THREE.Mesh(logoGeometry, logoMaterial)
    #    logoMesh.position.set(82,50,100)
    #    self.scene.add(logoMesh)


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
    #    self.scene.add(logoInnerMesh)


    #cutting off inner parts from logoMesh
    logoBSP = new ThreeBSP(logoMesh)
    innerBSP = new ThreeBSP(logoInnerMesh)
    innerBSP2 = new ThreeBSP(logoInnerMesh2)

#    finalLogoMaterial = new THREE.MeshLambertMaterial(
#      { color: 0x595959, vertexColors: THREE.VertexColors }
#    )

    materialFront = new THREE.MeshPhongMaterial(color: 0x595959)
    materialSide = new THREE.MeshPhongMaterial(color: 0x333333)
    materialArray = [materialFront, materialSide]
    finalLogoMaterial = new THREE.MeshFaceMaterial(materialArray)

    texture = new THREE.ImageUtils.loadTexture("images/textures/lensflare0.png")
    texture.wrapS = texture.wrapT = THREE.RepeatWrapping
    texture.repeat.set 0.05, 0.05
    #finalLogoMaterial = new THREE.MeshBasicMaterial(map: texture)

    newBSP = logoBSP.subtract(innerBSP).subtract(innerBSP2)
    newMesh = newBSP.toMesh(finalLogoMaterial)
    newMesh.scale.set(0.38, 0.38, 1)
    newMesh.position.set(55, 48, 100)

    self.logoMesh = newMesh
    #self.scene.add(newMesh)
  #end renderLogo

# add a wireframe to model
#    wireframeTexture = new THREE.MeshBasicMaterial(
#      color: 0x000000
#      wireframe: true
#      transparent: true
#    )
#    starMesh = new THREE.Mesh(starGeometry, wireframeTexture)
#    starMesh.position.set 0, 50, 0
#    self.scene.add(starMesh)

  renderText: ->
    self = this
    # add 3D text

    #texture for text
    texture = new THREE.ImageUtils.loadTexture("images/textures/3.png")
    texture.wrapS = texture.wrapT = THREE.RepeatWrapping
    texture.repeat.set 0.05, 0.05
    textTexture = new THREE.MeshBasicMaterial(map: texture)

    materialFront = new THREE.MeshPhongMaterial(color: 0x595959)
    materialSide = new THREE.MeshPhongMaterial(color: 0x333333)
    materialArray = [materialFront, materialSide]
    #materialArray = [textTexture, textTexture]
    textGeom = new THREE.TextGeometry("HANDSO    E",
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


    self.textMesh = new THREE.Mesh(textGeom, textMaterial)
    textGeom.computeBoundingBox()
    textWidth = (textGeom.boundingBox.max.x - textGeom.boundingBox.min.x)
    self.textMesh.position.set(-0.5 * textWidth, 50, 100)
    #self.textMesh.rotation.x = -Math.PI / 4
    self.textMesh.rotation.x = 0
    #self.scene.add(self.textMesh)
  #end renderText

  tmpLight: ->
    self = this
    self.scene.remove(self.light)

    # lights
    lensFlareUpdateCallback = (object) ->
      f = undefined
      fl = object.lensFlares.length
      flare = undefined
      vecX = -object.positionScreen.x * 2
      vecY = -object.positionScreen.y * 2
      f = 0
      while f < fl
        flare = object.lensFlares[f]
        flare.x = object.positionScreen.x + vecX * flare.distance
        flare.y = object.positionScreen.y + vecY * flare.distance
        flare.rotation = 0
        f++
      object.lensFlares[2].y += 0.025
      object.lensFlares[3].rotation = object.positionScreen.x * 0.5 + THREE.Math.degToRad(45)
    # lens flares
    addLight = (h, s, l, x, y, z) ->
      light = new THREE.PointLight(0xffffff, 1.5, 4500)
      light.color.setHSL h, s, l
      light.position.set x, y, z
      self.scene.add light
      flareColor = new THREE.Color(0xffffff)
      flareColor.setHSL h, s, l + 0.5
      lensFlare = new THREE.LensFlare(textureFlare0, 700, 0.0, THREE.AdditiveBlending, flareColor)
      lensFlare.add textureFlare2, 512, 0.0, THREE.AdditiveBlending
      lensFlare.add textureFlare2, 512, 0.0, THREE.AdditiveBlending
      lensFlare.add textureFlare2, 512, 0.0, THREE.AdditiveBlending
      lensFlare.add textureFlare3, 60, 0.6, THREE.AdditiveBlending
      lensFlare.add textureFlare3, 70, 0.7, THREE.AdditiveBlending
      lensFlare.add textureFlare3, 120, 0.9, THREE.AdditiveBlending
      lensFlare.add textureFlare3, 70, 1.0, THREE.AdditiveBlending
      lensFlare.customUpdateCallback = lensFlareUpdateCallback
      lensFlare.position = light.position
      self.scene.add lensFlare
    ambient = new THREE.AmbientLight(0xffffff)
    ambient.color.setHSL 0.1, 0.3, 0.2
    self.scene.add ambient
    dirLight = new THREE.DirectionalLight(0xffffff, 0.125)
    dirLight.position.set(0, -1, 0).normalize()
    self.scene.add dirLight
    dirLight.color.setHSL 0.1, 0.7, 0.5
    textureFlare0 = THREE.ImageUtils.loadTexture("images/textures/lensflare0.png")
    textureFlare2 = THREE.ImageUtils.loadTexture("images/textures/lensflare2.png")
    textureFlare3 = THREE.ImageUtils.loadTexture("images/textures/lensflare3.png")
    addLight 0.55, 0.9, 0.5, 5000, 0, -1000
    addLight 0.08, 0.8, 0.5, 0, 0, -1000
    addLight 0.995, 0.5, 0.9, 5000, 5000, -1000

  shaders: ->
    self = @
    uniforms = {
      time: { type: "f", value: 0 },
      resolution: { type: "v2", value: new THREE.Vector2 },
      texture: { type: "t", value: THREE.ImageUtils.loadTexture('images/textures/3.png') }
    }

    itemMaterial = new THREE.ShaderMaterial({
      uniforms: uniforms,
      vertexShader: document.getElementById('cubeVertexShader').innerHTML,
      fragmentShader: document.getElementById('cubeFragmentShader').innerHTML
    });
    self.shaderItem = new THREE.Mesh(new THREE.CubeGeometry(100, 10, 10), itemMaterial)
    @scene.add(self.shaderItem)

  smoke: ->
    self = @
    smokeParticles = new THREE.Geometry
    i = 0
    while i < 300
      particle = new THREE.Vector3(Math.random() * 32 - 16, Math.random() * 230, Math.random() * 32 - 16)
      smokeParticles.vertices.push(particle)
      i++
    smokeTexture = THREE.ImageUtils.loadTexture('images/smoke.png')
    smokeMaterial = new THREE.ParticleBasicMaterial({ map: smokeTexture, transparent: true, blending: THREE.AdditiveBlending, size: 50, color: 0x111111 })

    smoke = new THREE.ParticleSystem(smokeParticles, smokeMaterial)
    smoke.sortParticles = true
    smoke.position.set(0,100,200)
    self.scene.add(smoke)

  constructor: ->
    if $("#ThreeJS").size() is 0
      return false
    @renderScene()
    @renderSkybox()
    @renderLight()
    @createLightProjector()
    @renderPostament()
    #@shaders()
    #@smoke()
    #@tmpLight()
    #@createControl()

    @init()
#end constructor

$(->
  window.handsomeLogo = new HandsomeLogo()
)