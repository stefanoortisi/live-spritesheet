# live-spritesheet

Live Spritesheet is a wrapper class for [node-spritesheet](https://github.com/richardbutler/node-spritesheet) node module.
It watches into the src folder and compile the new spritesheet whenever some files change occurs.

## Requirements
You may need to install xquartz. A popup will be shown if required.

## Installation

	make install

## Usage
	
	live-spritesheet -c <your_config>.json


A config file look such as:

## config.json

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



