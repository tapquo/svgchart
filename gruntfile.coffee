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
        "src/coffee/helpers/*.coffee"
        "src/coffee/core/*.coffee"
        "src/coffee/ui/ui.coffee"
        "src/coffee/ui/ui.element.coffee"
        "src/coffee/ui/ui.element.*.coffee"
        "src/coffee/chart.coffee"
        "src/coffee/chart.*.coffee"
      ]
      styles: [
        "src/stylesheets/chart.styl"
        # "src/stylesheets/chart.*.styl"
        "src/stylesheets/tooltip.styl"
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

    copy:
      js: files: "site/components/svgchart/<%=pkg.name%>.js": "<%=meta.package%>/<%=pkg.name%>.<%=pkg.version%>.js"
      css: files: "site/components/svgchart/<%=pkg.name%>.css": "<%=meta.package%>/<%=pkg.name%>.<%=pkg.version%>.css"

    watch:
      coffee:
        files: ["<%= source.coffee %>"]
        tasks: ["coffee", "uglify", "copy:js"]
      styles:
        files: ["<%= source.styles %>"]
        tasks: ["stylus", "copy:css"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", ["coffee", "uglify", "copy", "stylus"]
