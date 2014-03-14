###
  The Class containing entities and keeping track of the update cycle
###
class World
  constructor: ->
    @entityList = []
    @idCount = 0
    @types = []
    
  #This function is called when the world is active and all references have been set by the engine
  begin: -> 
    #...
  
  #this function is called when the world leaves the screen
  end: ->
    #...
    
  add: (entity) ->
    entity.world = @ #keeping a reference on the world inside the entity
    entity.id = @idCount++
    @entityList.push(entity)
    
    @addEntityToTypes(entity)

  addEntityToTypes: (entity) ->
    #adding an entity to the types array
    if entity.type? and entity.type != ""
      if not @types[entity.type]
        @types[entity.type] = []
      @types[entity.type].push entity

  remove: (entity) ->
    e = @entityList.splice(@entityList.indexOf(entity), 1)
    
    #removing the entity from the
    if entity.type
      @types[entity.type]?.splice(@types[entity.type].indexOf(entity),1)
    
    #reseting the entity's world references
    e.world = null
    return e

  cycle: ->
    #clearing the canvas and saving the standard context
    Minze.context.clearRect(0, 0, Minze.canvas.width, Minze.canvas.height)
    Minze.context.save()
    
    #iterating all entities
    for entity in @entityList
      #updating the game logic for all entities
      entity?.update?()
      sprite = entity?.graphic

      #drawing debug information
      if entity?.hitbox.draw
        Minze.context.beginPath()
        Minze.context.lineWidth = 1
        Minze.context.strokeStyle = "#ff0000"
        Minze.context.rect(entity.x + entity.hitbox.offset.x, entity.y + entity.hitbox.offset.y, entity.hitbox.width, entity.hitbox.height)
        Minze.context.stroke()

      #only entities with a .graphic attribute can be drawn
      if sprite
        Minze.context.save()
        
        #drawX and drawY maybe set to 0 when a rotation is used
        drawX = Math.floor(entity.x)
        drawY = Math.floor(entity.y)
    
        #optional rotation
        if sprite.rotation? != 0
          Minze.context.translate(drawX, drawY)
          Minze.context.rotate(sprite.rotation * Minze.toRadian)
          drawX = 0
          drawY = 0
        
        #optional scaling
        if sprite.scale.x != 1 or sprite.scale.y != 1
          Minze.context.scale(sprite.scale.x, sprite.scale.y)
          
        #optional alpha/opacity if set on the graphic object
        if sprite.alpha? != 1
          Minze.context.globalAlpha = sprite.alpha
        
        #drawing the actual image... finally
        #either drawing an animated sprite or a static sprite
        if sprite.isAnimated
          sprite.update()
          spriteWidth = sprite.singleWidth
          spriteHeight = sprite.singleHeight
          spriteFrame = sprite.getCurrentFrame()
          #animated sprite out of a spritesheet
          Minze.context.drawImage(sprite.data, spriteFrame.x, spriteFrame.y, spriteWidth, spriteHeight, (drawX + sprite.offset.x), (drawY + sprite.offset.y), spriteWidth, spriteHeight)
        else
          #standard static sprite, no animation
          Minze.context.drawImage(sprite.data, (drawX + sprite.offset.x), (drawY + sprite.offset.y))
        
        Minze.context.restore()
        
      #calling the standard draw if provided by the entity, oh goddess how i love the ? operator
      entity?.render?()
      
    Minze.context.restore()
    
    #reseting the InputHandler
    Minze.input.reset() 