fs = require('fs')

nl = '\n'

joinFiles = (files, destination) ->
  out = files.map(
    (path) -> 
      return fs.readFileSync(path, 'utf-8')
  )
  fs.writeFileSync(destination, out.join(nl), 'utf-8')

collectFiles = (folders) ->
  out = []
  folders.forEach(
    (folder) ->
      fs.readdirSync(folder).forEach(
        (file) ->
          out.push folder+file 
      )
  )
  return out

#collect all src files
files = collectFiles(["src/minze/", "src/jmp0/"])
#and join them into one big coffee-script
joinFiles(files, 'release/Minze.coffee')