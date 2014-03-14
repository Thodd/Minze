###
  Generic Graphic class
###
class Sprite
  constructor: (asset) ->
    if(asset and asset.fileType == "image") 
      @data = asset.data
      @offset = x:0, y:0
      @rotation = 0
      @alpha = 1
      @scale = x:1, y:1
    else
      Minze.log("Sprite: The given asset is not an image! (#{asset})")

class AnimatedSprite extends Sprite
  constructor: (asset, @singleWidth, @singleHeight) ->
    super(asset)
    @isAnimated = true #yeah
    @animationPlaying = false
    @frames = []
    @animations = []
    
    #the number of rows and columns in the spritesheet
    @rows = Math.floor(@data.height / @singleHeight)
    @columns = Math.floor(@data.width / @singleWidth)
    
    #the number of sprites in the sheet
    @frameCount = @rows * @columns

    #precalculating the x/y coordinates of all frames
    tx = 0
    ty = 0
    for id in [0..(@frameCount-1)]
      @frames[id] = x:tx*@singleWidth, y:ty*@singleHeight
      if tx < (@columns-1)
        tx++
      else
        tx = 0
        ty++
    
    #the default animation is only the first frame
    @currentAnimation = @add("_default", [0], 30)

  add: (name, frames, frameRate) ->
    @animations[name] = 
      frames: frames
      frameCount: frames.length
      frameRate: frameRate or 60
      timer: 0
      index: 0                    #the index inside the frames array of the animation object
      currentFrame: frames[0]     #the actual index of the current frame (out of @frames)

  #starting an animation, reseting means the animation will start with the first frame again
  #otherwise an animation may be resumed from the last frame
  play: (animationName, reset = false) ->
    anim = @animations[animationName]
    if anim
      @currentAnimation = anim
      if reset
        @currentAnimation.index = 0
        @currentAnimation.timer = 0

  update: ->
    if @currentAnimation.timer < @currentAnimation.frameRate
      @currentAnimation.timer++
    else
      @currentAnimation.index++
      @currentAnimation.index = 0 if @currentAnimation.index >= @currentAnimation.frameCount
      @currentAnimation.currentFrame = @currentAnimation.frames[@currentAnimation.index]
      @currentAnimation.timer = 0
    
  getCurrentFrame: ->
    return @frames[@currentAnimation.currentFrame]
