less = require './less'
fs = require 'fs'

compile = () ->
  activeEditor = atom.workspace.getActiveEditor()

  if activeEditor
    filePath = activeEditor.getPath()

    if filePath.indexOf('.less') == filePath.length - 5
      text = activeEditor.getText()
      parser = new less.Parser

      parser.parse(text, (err, tree) =>
        if err
          console.log('Failed to compile less file for: ' + filePath)
          console.log(err)
          return

        css = tree.toCSS({compress: true})

        filenamePath = filePath.replace('.less', '.css')
        fs.writeFile(filenamePath, css, (err) ->
            if err
              console.log("Failed to save css file!")
        )
      )

module.exports =
  activate: (state) =>
    atom.workspaceView.command "less:compile", => compile()
    atom.workspaceView.command "core:save", => compile()

  deactivate: ->

  serialize: ->
