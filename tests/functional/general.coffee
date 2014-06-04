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

        path_1          = "example/nested/images"
        path_2          = "example/simple/src"
        
        config          = path.join path_1, "config.json"
        config_2        = path.join path_2, "config.json"
        wrong_config    = path.join path_2, "wrong_config.json"
        

        it 'it should watch with no errors', (done)->
            

            live.events.once 'built', ->

                assert.typeOf live.config, 'object'
                done()

            live.watch config


        it 'it should have saved the output files in the right directories', (done)->

            css_path = path.join live.config.output_css_folder, live.config.output_css
            image_path = path.join live.config.output_image_folder, live.config.output_image
            image_retina_path = path.join live.config.output_image_folder, live.config.output_image_retina


            css_path.should.be.a.path "The css file doesn't exists"
            image_path.should.be.a.path "The image file doesn't exists"
            image_retina_path.should.be.a.path "The retina image file doesn't exists"

            done()

        it 'it should deal with a config file in the same directory of the source images', (done)->
            

            live.events.once 'built', ->

                assert.typeOf live.config, 'object'
                done()

            live.watch config_2



        # it 'it should get an error if the some config path doesn\'t exists', (done) -> 


        #     live.events.once 'built', ->

        #         assert.typeOf live.config, 'object'
        #         done()

        #     live.watch wrong_config
