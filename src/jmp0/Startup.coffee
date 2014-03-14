#generic startup code for a game ;)
th.ready ->
  #Minze.debugMode = true
  Minze.logging = true
  Minze.debugMode = true
  Minze.init(th("#gamescreen").DOM) #a new game needs a reference to the canvas it will occupy
  
  #scheduling some assets for loading
  Minze.assets.add
    player: "res/char.png"
    pirate: "res/pirate_spritemap.png"
    tileset: "res/tileset_2bit.png"
    skeleton: "res/skeleton.png"
  
  #registering an event handler which will be called when all assets are loaded
  Minze.assets.onFinished = (success) ->
    if success
      mine = new TestWorld()
      Minze.start(mine)
    else
      Minze.log("Not all assets could be loaded successfully :(")
  
  #and an event handler for informing us of the loading progress
  Minze.assets.onProgress = (asset, success) ->
    msg = if success then "assets.onProgress: #{asset.key} has been loaded." else "assets.onProgress: #{asset.key} could not be loaded!"
    Minze.log(msg)
  
  #starting to load all assets
  Minze.assets.loadAll()
