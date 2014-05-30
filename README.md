# Live Spritesheet

Live Spritesheet is a extension for [node-spritesheet](https://github.com/richardbutler/node-spritesheet) node module.
It watches into the src folder and compile the new spritesheet whenever some files change occurs.

## Requirements

Requires [ImageMagick](http://www.imagemagick.org), available via HomeBrew (`$ sudo brew install ImageMagick`) or MacPorts: (`$ sudo port install ImageMagick`).

You may need to install xquartz. A popup will be shown if required.

## Installation

	make install

## Usage
	
	live-spritesheet -c <your_config>.json
	
	


A config file looks such as:

## config.json

````json
{
	"src_image_folder"		: "./src", # path
	"output_css_folder"  	: "./output/css", # path
	"output_image_folder"	: "./output/images", # path
	"selector"  			: ".sprite", # css selector
	"output_css"  	 		: "sprite.css", # filename
	"output_image"  		: "sprite.png", # filename
	"output_image_retina"	: "sprite-retina.png" # filename
}
````

