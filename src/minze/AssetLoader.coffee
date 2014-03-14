###
  A class for asynch asset-loading
###
class AssetLoader
  
  constructor: ->
    @scheduled = {} #resources scheduled for loading, identified by a given key (see 'add()')
    @loaded = {}    #the already loaded resources
    @loadingSuccess = true #this flag indicates if an error (no matter what kind) has occured during loading
    @finishedAssetRequests = 0 #the number of finished requests, successful or failed doesn't matter
    
  add: (urls) ->
    #iterating all given urls
    for own key, url of urls
      split = url.split "."
      fileExtension = split[split.length - 1]
      fileType = switch fileExtension
        when "png", "bmp", "jpg", "jpeg", "gif" then Asset.IMAGE
        when "mp3", "ogg", "wav"                then Asset.AUDIO
        when "xml"                              then Asset.XML
        when "json"                             then Asset.JSON
        when "csv"                              then Asset.CSV
        else Asset.UNKNOWN
      
      #adding the asset to the scheduling queue 
      if not @scheduled[key] and not @loaded[key]
        @scheduled[key] = new Asset(key, fileType, url)
        #count all scheduled assets... there has to be an easier way to do this... 
        @scheduledCount = if not @scheduledCount then 1 else (@scheduledCount+1)
      else 
        Minze.log("AssetLoader: Resource #{key} already added!")
    
  loadAll: ->
    #iterating all objects in the schedule
    for own key, asset of @scheduled
      switch asset.fileType
        when Asset.IMAGE then @loadImage(key, asset)
        when Asset.AUDIO then @loadAudio(key, asset)
        when Asset.CSV   then @loadCSV(key, asset)
        else Minze.log("AssetLoader: Unknown file type of asset #{key}!")

  #this function is needed to keep track of all loading request
  #this is necessary because the requests are asynchronous
  progress: ->
    @finishedAssetRequests++
    if @finishedAssetRequests == @scheduledCount
      @onFinished?(@loadingSuccess)

  loadImage: (key, asset) ->
    img = new Image()
    
    img.onload = =>
      asset.data = img
      @loaded[key] = asset
      @onProgress(asset, true)
      @progress() #needs to be called because all loading is asynchronous
    
    img.onerror = =>
      @loadingSuccess = false
      @onProgress(asset, false)
      @progress() #needs to be called because all loading is asynchronous
    
    img.src = asset.url #this triggers a request by the browser
    
  loadAudio: (key, asset) ->
    #loading audio
    
  loadCSV: (key, asset) ->
    #loading CSV

  #retrieving an asset
  get: (key) ->
    if @loaded[key]
      @loaded[key]
    else
      Minze.log("AssetLoader: Asset '#{key}' could not be found!")

###
  Aggregates the data of an asset and it's type, as well as some type constant
###
class Asset
  #static constants for Asset types
  @IMAGE    = "image"
  @AUDIO    = "audio"
  @XML      = "xml"
  @JSON     = "json"
  @CSV      = "csv"
  @UNKNOWN  = "unknown"
  
  constructor: (@key, @fileType, @url) ->
    #@data will be added dynamically through the assetloader!
