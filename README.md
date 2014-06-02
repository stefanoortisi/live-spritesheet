# Live Spritesheet

Live Spritesheet is a extension for [node-spritesheet](https://github.com/richardbutler/node-spritesheet) node module.

It watches into the src folder and compile the new spritesheet whenever some files change occurs.

## Requirements

Requires [ImageMagick](http://www.imagemagick.org), available via HomeBrew (`$ sudo brew install ImageMagick`) or MacPorts: (`$ sudo port install ImageMagick`).

You may need to install xquartz. A popup will be shown if required.

## Installation

	make install

## Usage
	
	bin/live-spritesheet -c <your_config>.json
	
	





## config.json

A config file looks such as:

````json
{
	"src_image_folder"		: "./src",
	"output_css_folder"  	: "./output/css",
	"output_image_folder"	: "./output/images",
	"selector"  			: ".sprite",
	"output_css"  	 		: "sprite.css",
	"output_image"  		: "sprite.png",
	"output_image_retina"	: "sprite-retina.png"
}
````

Where:

- src_image_folder (path)
- output_css_folder (path)
- output_image_folder (path)
- selector (css selector)
- output_css (filename)
- output_image (filename)
- output_image_retina (filename)



## TODO

- Improve error management (when files in config.json dont't exist)
