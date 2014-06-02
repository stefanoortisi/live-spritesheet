chai = require 'chai'
chai.use require('chai-fs')
should = do chai.should
assert = chai.assert
path = require 'path'


exports.test = ( live ) ->

    describe '[Basic Testing]', ->


        it 'it should have an "happens" instance as property', (done)->

            assert.typeOf live.events.on, 'function'
            done()

        it 'get_files_from_dir() should return an array', (done)->

            assert.typeOf (live.get_files_from_dir './'), 'array'
            assert.typeOf (live.get_files_from_dir '.'), 'array'
            assert.typeOf (live.get_files_from_dir '../'), 'array'
            assert.typeOf (live.get_files_from_dir '..'), 'array'

            done()

    describe '[Core Functionalities]', ->

        example_path = "example/nested/images"
        config = path.join( example_path, "config.json" )

        it 'it should watch with no errors', (done)->
            

            live.events.on 'built', ->

                assert.typeOf live.config, 'object'
                done()

            live.watch config
            live._compile()


        it 'it should have saved the output files in the right directories', (done)->

            css_path = path.join live.config.output_css_folder, live.config.output_css
            image_path = path.join live.config.output_image_folder, live.config.output_image
            image_retina_path = path.join live.config.output_image_folder, live.config.output_image_retina


            css_path.should.be.a.path "The css file doesn't exists"
            image_path.should.be.a.path "The image file doesn't exists"
            image_retina_path.should.be.a.path "The retina image file doesn't exists"

            done()
