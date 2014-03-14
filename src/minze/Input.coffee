class InputManager
  constructor: -> 
    @keyDownList = []
    @pressedList = []
    @symbolicNames = []
    @pressedCount = 0
    
    #setting up the event handlers
    window.addEventListener "keydown", (e) =>
        @eventCorrection(e, @keyDownHandler)
    
    window.addEventListener "keyup", (e) =>
        @eventCorrection(e, @keyUpHandler) 

  keyDownHandler: (evt) =>
    if not @keyDownList[evt.keyCode]
      @keyDownList[evt.keyCode] = true
      @pressedList[@pressedCount++] = evt.keyCode
    
  keyUpHandler: (evt) =>
    if @keyDownList[evt.keyCode]
      @keyDownList[evt.keyCode] = false
        
  eventCorrection: (evt, handler) ->
    evt = evt or window.event
    handler(evt)
    
  define: (symbolics) ->
    for key, value of symbolics
      @symbolicNames[key] = value
      
  isKeyDown: (key) ->
    #first try to get the key from the symbolicNames table
    #after that retrieve it from the keyDownList
    symbol = @symbolicNames[key]
    if not symbol
      return @keyDownList[key]
    else
      return @keyDownList[symbol]
  
  wasPressed: (key) ->
    symbol = @symbolicNames[key]
    if not symbol
      return @pressedList.indexOf(key) >= 0
    else
      return @pressedList.indexOf(symbol) >= 0
      
  reset: ->
    while @pressedCount--
      @pressedList[@pressedCount] = 0
    @pressedCount = 0

#Key Constants
Keys = 
    BACKSPACE:  8
    TAB:        9
    ENTER:      13
    SHIFT:      16
    CONTROL:    17
    ALT:        18
    PAUSE:      19
    CAPSLOCK:   20
    ESC:        27
    SPACE:      32
    PAGE_UP:    33
    PAGE_DOWN:  34
    END:        35
    HOME:       36
    LEFT:       37
    UP:         38
    RIGHT:      39
    DOWN:       40 
    INSERT:     45
    DELETE:     46
    MULTIPLY:   106
    ADD:        107
    SUBTRACT:   109
    POINT:      110
    DIVIDE:     111
    NUMLOCK:    144
    SCROLLLOCK: 145
    SEMICOLON:  186
    EQUALS:     187
    COMMA:      188
    DASH:       189
    PERIOD:     190
    SLASH:      191
    ACCENTGRAVE:192
    BACKSLASH:  220