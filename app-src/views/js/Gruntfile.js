module.exports = function (grunt) {
  grunt.initConfig(
    { pkg             : grunt.file.readJSON('package.json')
    , browserify      :
      { tests         :
        { src         : 'tests/browser-tests.coffee'
        , dest        : 'browser/tests.js'
        , options     :
          { transform : ['coffeeify']
          , alias     :
            [ 'common/page.coffee:page'
            ]
          }
        }
      }
    , connect         :
      { tests         :
        { options     :
          { port      : 9001
          , base      : 'browser'
          }
        }
      }
    , watch           :
      { tests         :
        { files       : ['tests/**/*.coffee']
        , tasks       : ['default']
        }
      }
    }
  )

  grunt.loadNpmTasks('grunt-browserify')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.registerTask('default', ['browserify:tests'])

  grunt.registerTask('run-tests', ['connect:tests', 'watch:tests'])
}
