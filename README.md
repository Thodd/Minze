Minze
=====

Minze.coffee (german for `mint`) is a simple Canvas based game engine build with Coffee Script.

Live Demo:
http://thodd.net/demos/Minze.coffee/

The demo shows:
 * multiple animated (and rotating) Sprites
 * Keyboard input
 * Asset loading
 * Collision detection

### Prep ###
1. Install http://nodejs.org/
2. Install http://coffeescript.org/ (duh)

You will most likely need a webserver to load up images, music etc.
Which webserver you use is not important, but to give you a head start:

The server.js file "implements" a simple webserver based on the node js module `connect`.

You can install http://www.senchalabs.org/connect/ run this command in your game directory:

`npm install connect`

### Basic Idea ###
Minze is addressed at game developers familiar with GameMaker or Flashpunk. Both tools build around a simple an 
update and render loop, and so does Minze. The Collision detection currently implemented was also inspired by 
Flashpunk and GameMaker.

1. You create a `World` instance (or let your own class inherit from World)
2. You add some `Entity` instances to the world
3. Each entity implements an update function, this code gets called with about ~60fps (ideally)
4. Add the entities to the World instance
5. Finally call `Minze.start(world)`

A simple example can be found in the `src/jmp0` folder. See also the live demo linked above.

### Building ###
Ok now this is a little different from "classic" coffee script projects.
As said, Minze is aimed at developers and game makers, with no interest in build scripts, asynchronous stuff, and so on.
Minze therefore uses a very simple `nake.coffee` pseudo-build script.

In the `nake.coffee` file you will find the following line:

`files = collectFiles(["src/minze/", "src/jmp0/"])`

exchange the `src/jmp0/` part with any folder you put your code in, and extend this array by adding additional folders if necessary.

Afterwards, to build your project, run the following commands:

1. `coffee nake.coffee` 
This concatenates all coffee files you specify in the `nake.coffee` file to one big `Minze.coffee` file in the release folder.

2. `coffee -o release -c release\Minze.coffee`

And your done, you now have one big `Minze.js` file in your release folder. Load it up in your browser and your game will run.

### Dependencies ###
None actually... just basic canvas goodness.
In the `libs` folder you can find a simple JavaScript lib to abstract some DOM functions.

Use `th.ready(function(){...})` in to execute code when the document is ready. Same as jQuery.

Use `th("#something")` to retrieve a DOM element.

### TODO ###
1. Implement Audio Support
2. Implement Mouse Events
3. Implement Touch Events
4. Write a documentation and add additional Samples.
5. Some stuff i forgot...

