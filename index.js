#!/usr/bin/env node

_        		= require( 'lodash-node' );
path 			= require( 'path' );
fsu      		= require( 'fs-util' );
fs      		= require( 'fs' );
Builder  		= require( 'node-spritesheet' ).Builder;
argv  			= require( 'minimist' )( process.argv.slice(2));

if (typeof argv.c == "undefined") {
    console.error('ERROR: Parameter -c required.');
    return;
}

// Normalize the config file path
if( argv.c.indexOf( './' ) != 0 ) {
	argv.c = './' + argv.c;
}

// Get the config file
var config = require( argv.c );


// Resolve the paths
var config_dirname = path.dirname( argv.c );
config.src_image_folder  = path.resolve( config_dirname, config.src_image_folder );
config.output_css_folder    = path.resolve( config_dirname, config.output_css_folder );
config.output_image_folder = path.resolve( config_dirname, config.output_image_folder );

var css_original_path = config.output_image_folder + "/" + config.output_css;


// Set the debounce function
var on_change = _.debounce( compile, 1000, { 
	leading: false, 
	trailing: true 
});

// Watch the files
var watcher = fsu.watch( config.src_image_folder, /.*/, true );
watcher.on( 'watch', on_change );
watcher.on( 'create', on_change );
watcher.on( 'change', on_change );
watcher.on( 'delete', on_change );


// Compile the spritesheet
function compile() {
	var builder = new Builder({
		outputDirectory : config.output_image_folder,
		outputCss  		: config.output_css,
		selector  		: config.selector,
		images 			: get_files_from_dir( config.src_image_folder )
	});

	builder.addConfiguration( "legacy", {
		pixelRatio: 1,
		outputImage: config.output_image
	});

	builder.addConfiguration( "retina", {
		pixelRatio: 2,
		outputImage: config.output_image_retina
	});

	builder.build( function() {
		var css_original_path = config.output_image_folder + "/" + config.output_css;
		var css_new_path = config.output_css_folder + "/" + config.output_css;
			
		move_css( css_original_path, css_new_path );

		console.log( "Build from " + builder.files.length + " images. Press CTRL+C to exit." );
	} );

}


function move_css( old_path, new_path ) {

	// Get the relative path from the old to the new path
	var prefix_url = path.relative( path.dirname( new_path ), path.dirname( old_path ) ) + "/";

	// Create a regexp for each spritesheet
	var reg_1 = new RegExp(config.output_image,"g");
	var reg_2 = new RegExp(config.output_image_retina,"g");

	// Get the new url to update into the css
	var new_name = prefix_url + config.output_image;
	var new_name_retina = prefix_url + config.output_image_retina;

	
	// Open the old file
	fs.readFile( old_path, 'utf8', function (err,data) {
		if (err) { return console.console.log(err); }

		// Update the path for the images
		var result = data.replace(reg_1, new_name);
		result = result.replace(reg_2, new_name_retina);

		// Write and rename the file
		fs.writeFile( old_path, result, 'utf8', function (err) {
			if (err) return console.console.log(err);

			fs.renameSync( old_path, new_path );
		});
	});
	
}

function get_files_from_dir( dir ) {
	files = fs.readdirSync( dir );

	var output = [];
	for( var i = 0; i < files.length; i++ ) {
		if( files[ i ][ 0 ] != '.' ) {
			output.push( dir + '/' + files[ i ] );
		}
	}

	return output;
}

