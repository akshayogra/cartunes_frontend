module.exports = function (grunt) {
  grunt.initConfig(
    { pkg             : grunt.file.readJSON('package.json')
    , concurrent      :
      { dev           :
        { tasks       : ['watch', 'nodemon']
        , options     : { logConcurrentOutput : true }
        }
      }
    , coffee          :
      { app           :
        { options     :
          { bare      : true
          }
        , expand      : true
        , cwd         : 'app-src'
        , src         : ['**/*.coffee', '!views/**']
        , dest        : 'app'
        , ext         : '.js'
        }
      }
    , nodemon         :
      { dev           :
        { script      : 'server.js'
        , options     :
          { ext       : 'js'
          , watch     : ['app']
          , delay     : 3
          }
        }
      }
    , browserify      :
      { default       :
        { src         : 'app-src/views/js/index.coffee'
        , dest        : 'app/public/js/dist.js'
        , options     :
          { transform : ['coffeeify']
          , alias     :
            [ './app-src/views/js/page.coffee:page'
            ]
          }
        }
      }
    , uglify          :
      { default       :
        { src         : 'app/public/js/dist.js'
        , dest        : 'app/public/js/dist.min.js'
        }
      }
    , watch           :
      { coffee        :
        { files       : ['app-src/**/*.coffee']
        , tasks       : ['default']
        }
      }
    }
  )

  grunt.loadNpmTasks('grunt-concurrent')
  grunt.loadNpmTasks('grunt-nodemon')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-browserify')

  grunt.registerTask('javascript', ['browserify', 'uglify'])
  grunt.registerTask('start-dev-server', ['default', 'concurrent:dev'])
  grunt.registerTask('default', ['coffee', 'javascript'])
}
