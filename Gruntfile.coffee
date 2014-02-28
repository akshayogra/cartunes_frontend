module.exports = (grunt) ->
  grunt.initConfig
    pkg             : grunt.file.readJSON('package.json')
    concurrent      :
      dev           :
        tasks       : ['watch', 'nodemon']
        options     : { logConcurrentOutput : true }
    nodemon         :
      dev           :
        script      : 'server.js'
        options     :
          ext       : 'js'
          watch     : ['app']
          ignore    : ['app/public']
          delay     : 3
    browserify      :
      default       :
        src         : 'app-src/views/js/index.coffee'
        dest        : 'app/public/js/dist.js'
        options     :
          transform : ['coffeeify']
          alias     : ['./app-src/views/js/lib/page.coffee:page']
          debug     : true
    uglify          :
      default       :
        src         : 'app/public/js/dist.js'
        dest        : 'app/public/js/dist.min.js'
    watch           :
      views         :
        files       : ['app-src/views/**/*.coffee']
        tasks       : ['javascript']

  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-browserify'

  grunt.registerTask 'javascript', ['browserify', 'uglify']
  grunt.registerTask 'start-dev-server', ['default', 'concurrent:dev']
  grunt.registerTask 'default', ['javascript']
