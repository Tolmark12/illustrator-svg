fs = require 'fs'

{print} = require 'util'
{spawn, exec} = require 'child_process'
try
  which = require('which').sync
catch err
  if process.platform.match(/^win/)?
    console.log 'WARNING: the which module is required for windows\ntry: npm install which'
  which = null

bold = '\x1b[0;1m'
green = '\x1b[0;32m'
reset = '\x1b[0m'
red = '\x1b[0;31m'

# --------------------------------- TASKS

task 'build', 'compile source', -> build( -> log("√", green) )
task 'watch', 'watch for changes, compile to file', -> watchSrc( -> log )

jsFile = "xvg.jsx"
src    = 'src/'

build = ( callback ) ->
  launch 'coffee', ['-j', jsFile, '-c', src], callback

watchSrc = ( callback ) ->
  launch 'coffee', ['-w', '-j', jsFile, '-c', src], callback


# --------------------------------- Helpers

launch = (cmd, options=[], callback) ->
  cmd = which(cmd) if which
  app = spawn cmd, options
  app.stdout.pipe(process.stdout)
  app.stderr.pipe(process.stderr)
  app.on 'exit', (status) -> callback?() if status is 0

log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')
