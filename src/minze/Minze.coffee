###
  The Game Engine contains the gameloop and
  takes care of all updating and rendering,
  as well as some static convenience functions
###
Minze =
  init: (@canvas) ->
    @context = @canvas.getContext("2d")
    @isRunning = false
    @toRadian = Math.PI / 180
    @assets = new AssetLoader()
    @input = new InputManager()
    
  switchWorld: (world) ->
    @currentWorld?.end()
    
    @currentWorld = world
    #keeping a reference on the current Minze-Game inside the world, will be accessed by entities
    #@currentWorld.minze = this
    
    @currentWorld.begin?()
    
  start: (world) ->
    if !@isRunning
      @isRunning = true
      @switchWorld(world)
      
      # simple but effective game loop, all real gamelogic is handled by the world/entities
      # note the fat arrow for binding this to the object instance of the Minze class!
      gameLoop = =>
        if @isRunning
          @currentWorld.cycle() #update cycle
          @currentWorld.render?() #optional render cycle for the world
          requestAnimFrame(gameLoop)
      
      gameLoop() #kickstarting the gameloop
      
    else
      Minze.log("this game is already running")
      
    return null

  log: (msg) ->
    if @logging then console.log(msg)
