fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'

build = (callback) ->
  #joining all files together to create a single .coffee file
  join = spawn 'coffee.cmd', ['nake.coffee']
  #compiling the files
  coffee = spawn 'coffee.cmd', ['--join', 'release/Minze.js', '--compile', 'src/minze', 'src/jmp0']
  coffee.stderr.on 'data', (data) ->
    console.log(data.toString())
  coffee.stdout.on 'data', (data) ->
    console.log(data.toString())
  coffee.on 'exit', (code) ->
    callback?() if code is 0

finished = ->
  console.log("everything went well :)")

task 'build', 'Build lib/ from src/', ->
  build(finished)