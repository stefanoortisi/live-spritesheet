_        		= require( 'lodash-node' );
path 			= require( 'path' );
fsu      		= require( 'fs-util' );
fs      		= require( 'fs' );
Builder  		= require( 'node-spritesheet' ).Builder;
argv  			= require( 'minimist' )( process.argv.slice(2));
happens 		= require 'happens'

module.exports = class LiveSpritesheet

	config: null

	constructor: ( ) ->
		@events = happens()


	watch: ( config_path ) ->
		# Normalize the config file path
		config_path = path.join( process.cwd(), config_path)

		# Get the config file and validate it
		@config = require( config_path );


		cond_1 = @check_filename( @config.output_css )
		cond_2 = @check_filename( @config.output_image )
		cond_3 = @check_filename( @config.output_image_retina )

		if not cond_1 or not cond_2 or not cond_3 
			@error "output_css, output_image and output_image_retina need to be a filename and not a path."
			return

		# Resolve the paths
		config_dir  				= path.dirname config_path
		@config.src_image_folder    = path.resolve config_dir, @config.src_image_folder
		@config.output_css_folder   = path.resolve config_dir, @config.output_css_folder
		@config.output_image_folder = path.resolve config_dir, @config.output_image_folder

		css_original_path = path.join @config.output_image_folder, @config.output_css

		# Set the debounce function
		on_change = _.debounce @_compile, 1000,
			leading: false, 
			trailing: true 

		# Watch the files
		watcher = fsu.watch @config.src_image_folder, /.*/, true
		watcher.on 'watch', on_change
		watcher.on 'create', on_change
		watcher.on 'change', on_change
		watcher.on 'delete', on_change


	_compile: ( ) =>

		builder = new Builder({
			outputDirectory : @config.output_image_folder,
			outputCss  		: @config.output_css,
			selector  		: @config.selector,
			images 			: @get_files_from_dir @config.src_image_folder
		});

		builder.addConfiguration "legacy",
			pixelRatio: 1,
			outputImage: @config.output_image

		builder.addConfiguration "retina",
			pixelRatio: 2,
			outputImage: @config.output_image_retina

		builder.build =>
			css_original_path = @config.output_image_folder + "/" + @config.output_css;
			css_new_path = @config.output_css_folder + "/" + @config.output_css;
				
			@move_css css_original_path, css_new_path

			@events.emit 'built', builder.files
			console.log "Build from #{builder.files.length} images. Press CTRL+C to exit."

	move_css: ( old_path, new_path ) ->

		# Get the relative path from the old to the new path
		prefix_url = path.relative( path.dirname( new_path ), path.dirname( old_path ) ) + "/";

		# Create a regexp for each spritesheet
		reg_1 = new RegExp @config.output_image, "g"
		reg_2 = new RegExp @config.output_image_retina, "g"

		# Get the new url to update into the css
		new_name = prefix_url + @config.output_image;
		new_name_retina = prefix_url + @config.output_image_retina;

		
		# Open the old file
		fs.readFile old_path, 'utf8', (err,data) ->
			if (err)
				@error err
				return console.log(err)

			# Update the path for the images
			result = data.replace(reg_1, new_name);
			result = result.replace(reg_2, new_name_retina);

			# Write and rename the file
			fs.writeFile old_path, result, 'utf8', (err) ->
				if (err) 
					@error err
					return console.log(err);

				fs.renameSync old_path, new_path


	get_files_from_dir: ( dir ) ->
		unless fs.existsSync dir
			@error "Directory #{dir} doesn't exist."
			return []

		files = fs.readdirSync dir

		output = [];
		for item in files
			if item[ 0 ] != '.' 
				output.push( path.join dir, item )

		return output


	check_filename: ( test ) ->
		if test.indexOf( "/" ) != -1
			console.error( 'ERROR: '+ test +' needs to be a filename and not a path.' );
			return false
		return true	
		



	error: ( message ) ->
		console.error message
		@events.emit "error", message
