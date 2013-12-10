module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"

    meta:
      package  : "dist",
      temp     : "temp",
      banner   : """
        /* <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("m/d/yyyy") %>
           <%= pkg.homepage %>
           Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %> - Licensed <%= _.pluck(pkg.license, "type").join(", ") %> */

        """
    # =========================================================================

    source:
      coffee: [
        "src/coffee/core.coffee"
        "src/coffee/core.*.coffee"
        "src/coffee/chart.coffee"
        "src/coffee/chart.*.coffee"
      ]
      styles: [
        "src/stylesheets/chart.styl"
        "src/stylesheets/chart.*.styl"
      ]

    coffee:
      options: join: true
      all: files: "<%= meta.package %>/<%= pkg.name %>.<%= pkg.version %>.debug.js": "<%= source.coffee %>"

    uglify:
      options: compress: false, mangle: false, banner: "<%= meta.banner %>"
      all: files: "<%=meta.package%>/<%=pkg.name%>.<%=pkg.version%>.js": "<%=meta.package%>/<%=pkg.name%>.<%=pkg.version%>.debug.js"

    stylus:
      options: compress: true, import: [ '__constants']
      all:
        files: "<%= meta.package %>/<%= pkg.name %>.<%= pkg.version %>.css": "<%= source.styles %>"

    watch:
      coffee:
        files: ["<%= source.coffee %>"]
        tasks: ["concat", "coffee", "uglify"]
      styles:
        files: ["<%= source.styles %>"]
        tasks: ["stylus"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", ["coffee", "uglify", "stylus"]
