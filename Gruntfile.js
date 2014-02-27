module.exports = function (grunt) {
  grunt.initConfig(
    { pkg         : grunt.file.readJSON('package.json')
    , concurrent  :
      { dev       :
        { tasks   : ['watch', 'nodemon']
        , options :
          { logConcurrentOutput : true
          }
        }
      }
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
    , nodemon     :
      { dev       :
        { script  : 'server.js'
        , options :
          { ext   : 'js'
          , watch : ['app']
          , delay : 1
          }
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

  grunt.loadNpmTasks('grunt-concurrent')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-nodemon')

  grunt.registerTask('default', ['coffee'])
  grunt.registerTask('start-dev-server', ['default', 'concurrent:dev'])
}
