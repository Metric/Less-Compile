less = require 'less'
fs = require 'fs'
path = require 'path'
{Function} = require 'loophole'

compile = () ->
  oldFunc = global.Function
  global.Function = Function
  activeEditor = atom.workspace.getActiveTextEditor()

  if activeEditor
    filePath = activeEditor.getPath()

    if filePath and filePath.indexOf('.less') == filePath.length - 5
      text = activeEditor.getText()
      parser = new less.Parser({paths: [path.dirname(filePath)]})

      parser.parse(text, (err, tree) =>
        if err
          console.log('Failed to compile less file for: ' + filePath)
          console.log(err)
          global.Function = oldFunc
          return

        css = tree.toCSS({compress: true})

        filenamePath = filePath.replace('.less', '.css')
        fs.writeFile(filenamePath, css, (err) ->
            if err
              console.log("Failed to save css file!")
        )

        global.Function = oldFunc
      )
    else
      global.Function = oldFunc
  else
    global.Function = oldFunc

module.exports =
  activate: (state) =>
    atom.commands.add "atom-workspace",
      "less:compile": (event) =>
        compile()
    atom.commands.add "atom-workspace",
      "core:save": (event) =>
        compile()

  deactivate: ->

  serialize: ->
