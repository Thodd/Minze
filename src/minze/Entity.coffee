### 
  a single gameplay entity placed in the world
###
class Entity
  constructor: (x, y) ->
    #all entities get injected with a reference on their current world!
    
    #default position of an entity
    @x = x or 0
    @y = y or 0
    
    #default empty hitbox
    @hitbox =
      offset:
        x:0
        y:0
      width: 0
      height: 0
      draw: false
    
  setType: (@type) ->
    @world?.addEntityToTypes(@)

  #placing the entity at (x,y) and doing a collision check against all other entities of the given type
  collide: (x, y, type) ->
    #the collision result
    collisions = []
    
    if @world
      #finding the entity list to check against
      checkAgainst = if type then @world.types[type] else @world.entityList 
      
      if checkAgainst
        for e in checkAgainst
          #exlude self from collision check ;)
          if e != @
            collisions.push(e) if collisionCheck(@, e, x, y)
    
    return collisions
    
  #simple collision check between 2 entities
  collisionCheck = (entity1, entity2, e1_x, e1_y) ->
    x1 = e1_x + entity1.hitbox.offset.x
    x2 = entity2.x + entity2.hitbox.offset.x
    y1 = e1_y + entity1.hitbox.offset.y
    y2 = entity2.y + entity2.hitbox.offset.y
    
    right1 = x1 + entity1.hitbox.width
    right2 = x2 + entity2.hitbox.width
    bottom1 = y1 + entity1.hitbox.height
    bottom2 = y2 + entity2.hitbox.height
    
    if bottom1 < y2
      return false
        
    if y1 > bottom2
      return false
        
    if right1 < x2
      return false
        
    if x1 > right2
      return false
      
    return true