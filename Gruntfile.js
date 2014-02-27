module.exports = function (grunt) {
  grunt.initConfig(
    { pkg         : grunt.file.readJSON('package.json')
    , coffee      :
      { app       :
        { options :
          { bare  : true
          }
        , expand  : true
        , cwd     : 'app-src'
        , src     : ['**/*.coffee']
        , dest    : 'app'
        , ext     : '.js'
        }
      }
    , watch       :
      { coffee    :
        { files   : ['app-src/**/*.coffee']
        , tasks   : ['coffee:app']
        }
      }
    }
  )

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.registerTask('default', ['coffee'])
}
