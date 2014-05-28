_        		= require 'lodash-node'
path 			= require 'path'
fsu      		= require 'fs-util'
fs      		= require 'fs'
Builder  		= require( 'node-spritesheet' ).Builder
argv  			= require( 'minimist' )( process.argv.slice(2))

class Index

	constructor: ( ) ->

		if argv.c?
			@init()
		else
			console.error "ERROR: Parameter required: -c", 



	init: ( ) ->
		argv.c = "./#{argv.c}"  if argv.c.indexOf "./" isnt 0
			
		@config = require argv.c

		on_change = _.debounce @on_files_change, 1000, leading: false, trailing: true

		# watch files
		watcher = fsu.watch @config.src_folder, /.*/, true

		watcher.on 'watch' , on_change
		watcher.on 'create', on_change
		watcher.on 'change', on_change
		watcher.on 'delete', on_change

		# flush the output folder
		files = @get_files_from_dir @config.output_folder
		fs.unlinkSync file for file in files

	compile: ( ) ->
		@builder = new Builder
			outputDirectory: @config.output_folder,
			outputCss: @config.output_css,
			selector: @config.selector
			images: @get_files_from_dir @config.src_folder

		@builder.addConfiguration "legacy",
			pixelRatio: 1,
			outputImage: @config.output_image

		@builder.addConfiguration "retina",
			pixelRatio: 2,
			outputImage: @config.output_image_retina

		@builder.build =>
			console.log "Build from #{@builder.files.length} images."

	on_files_change: ( ) =>
		console.log 'on files change'
		@compile()

	get_files_from_dir: ( dir ) ->
		files = fs.readdirSync dir

		output = []
		for item, i in files
			
			if item[0] isnt '.'
				output.push "#{dir}/#{item}" 

		return output

new Index()