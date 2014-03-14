###
       TESTS
###
class TestWorld extends World
  begin: ->
    super()
    
    for i in [0..999]
      @add(new Skeleton(Math.floor(Math.random()*300), Math.floor(Math.random()*220)))
    @add(new Skeleton(Math.floor(Math.random()*300), Math.floor(Math.random()*220)))
    
    #Adding some random placed boxes
    for i in [1..25]
      @add(new Wall(Math.floor(Math.random()*300), Math.floor(Math.random()*220)))
    
    Minze.input.define
      shoot:  Keys.SPACE
      left:   Keys.LEFT
      right:  Keys.RIGHT
      up:     Keys.UP
      down:   Keys.DOWN
    
    #ch0 = new Char(0, 0, .5)
    #@add ch0
    ch = new Char(0, 0, 1)
    @add ch
    #ch2 = new Char(0, 0, 1.5)
    #@add ch2
    #ch3 = new Char(0, 0, 2)
    #@add ch3

class Wall extends Entity
  constructor: (x, y) ->
    super(x, y)
    @graphic = new AnimatedSprite(Minze.assets.get("tileset"), 16, 16)
    @setType("wall")
    @hitbox.width = 16
    @hitbox.height = 16
    @hitbox.draw = true

class Char extends Entity
  constructor: (x, y, @speed) ->
    super(x, y)
    @graphic = new AnimatedSprite(Minze.assets.get("pirate"), 20, 20)
    @graphic.add("walk_down", [0,1,2,3], 10)
    @graphic.add("walk_up", [6,7,8,9], 10)
    @graphic.add("walk_left", [18,19], 10)
    @graphic.add("walk_right", [12,13], 10)
    
    #@graphic = new Sprite(Minze.assets.get("player"))
    @setType("char")
    
    @hitbox.width = 16
    @hitbox.height = 16
    @hitbox.offset = x:2, y:2
    @hitbox.draw = true
    
  update: ->
    if Minze.input.wasPressed "shoot"
      Minze.log "sho~oting"
    
    xDif = 0
    yDif = 0
    
    if Minze.input.isKeyDown "left"
      xDif = -@speed
      @graphic.play("walk_left")
    if Minze.input.isKeyDown "right"
      xDif = @speed
      @graphic.play("walk_right")
    if Minze.input.isKeyDown "up"
      yDif = -@speed
      @graphic.play("walk_up")
    if Minze.input.isKeyDown "down"
      yDif = @speed
      @graphic.play("walk_down")
    
    if xDif != 0 or yDif != 0
      if @collide(@x + xDif, @y, "wall").length == 0
        @x += xDif
      if @collide(@x, @y + yDif, "wall").length == 0
        @y += yDif


class Skeleton extends Entity
  constructor: (x, y) ->
    super(x, y)
    @xDir = if Math.random() > 0.5 then -1 else 1
    @yDir = if Math.random() > 0.5 then -1 else 1
    @speed = 1 + Math.floor(Math.random() * 3)

    @graphic = new AnimatedSprite(Minze.assets.get("tileset"), 16, 16)
    @graphic.add("skel", [1, 7, 17, 43])
    @graphic.play("skel")
    
    #@graphic = new Sprite(Minze.assets.get("skeleton"))
    @graphic.offset = x:-8, y:-8
    
    @alphaFlash = 0.01
    @scaleFactor = 0.1
    
    @setType("skeleton")
    
    @hitbox.offset = x:-8, y:-8
    @hitbox.width = 16
    @hitbox.height = 16

  rotate: ->
    @graphic.rotation += 1
    @graphic.rotation %= 360

  flash: ->
    @graphic.alpha += @alphaFlash
    @graphic.alpha = 1 if @graphic.alpha > 1
    @graphic.alpha = 0 if @graphic.alpha < 0
    if @graphic.alpha == 1 or @graphic.alpha == 0
      @alphaFlash *= -1

  scale: ->
    @graphic.scale.x += @scaleFactor
    @graphic.scale.y += @scaleFactor
    @graphic.scale.x = 4 if @graphic.scale.x > 4
    @graphic.scale.y = 4 if @graphic.scale.y > 4
    @graphic.scale.x = 0 if @graphic.scale.x < 0
    @graphic.scale.y = 0 if @graphic.scale.y < 0
    if @graphic.scale.x == 4 or @graphic.scale.y == 4 or @graphic.scale.x == 0 or @graphic.scale.y == 0
      @scaleFactor *= -1

  update: ->
    newX = @x + @xDir * @speed
    newY = @y + @yDir * @speed
    
    if newX > 0 and newX < 304
      @x = newX
    else
      @xDir *= -1
      
    if newY > 0 and newY < 224
      @y = newY
    else
      @yDir *= -1

    #@scale()
    #@rotate()
    #@flash()
    
    #@collide(@x, @y, "char").length > 0
    #if @collide(@x, @y, "char").length > 0
      #@world.remove(@)
