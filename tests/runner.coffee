fsu  = require 'fs-util'
path = require 'path'
LiveSpritesheet = require '../dist/index.js'

# list of test files
files = fsu.find (path.join __dirname, 'functional'), /\.coffee$/m

# pivot = new Pivot()

live = new LiveSpritesheet


for file in files
	test = ( require file ).test
	test( live )