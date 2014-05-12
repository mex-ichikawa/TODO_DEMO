module.exports = (grunt) ->
	"use strict"

	#パッケージ情報読み込み
	pkg = grunt.file.readJSON 'package.json'

	#全てのnpmタスク読み込み
	for taskName of pkg.devDependencies when taskName.substring(0, 6) is 'grunt-'
		grunt.loadNpmTasks taskName

	#各タスク設定
	grunt.initConfig
		#設定引き継ぎ
		pkg: pkg
		#ファイル結合
		concat:
			coffee:
				src: [
					'src/coffee/Env.coffee'
					'src/coffee/Config.coffee'
					'src/coffee/Lang.coffee'
					'src/coffee/util/**/*.coffee'
					'src/coffee/App.coffee'
					'src/coffee/**/*.coffee'
					'!src/coffee/Main.coffee'
					'src/coffee/Main.coffee'
					'!src/coffee/build/**/*.coffee'
				]
				dest: 'src/coffee/build/main.coffee'
			vendor:
				options:
					separator: "\n;\n"
				src: [
					'vendor/bower/underscore/underscore.js'
					'vendor/bower/underscore.string/lib/underscore.string.js'
					'vendor/bower/angular/angular.js'
					'vendor/bower/angular-route/angular-route.js'
					'vendor/bower/angular-bootstrap/ui-bootstrap-tpls.js'
					'vendor/bower/parse-js-sdk/lib/parse.js'
				]
				dest: 'src/js/vendor.js'

		#coffeeスクリプトコンパイル
		coffee:
			compile:
				src: 'src/coffee/build/main.coffee'
				dest: 'src/js/main.js'
				options:
					sourceMap: true

		#sass
		compass:
			dist:
				options:
					sassDir: 'src/scss'
					cssDir: 'src/css'
					raw: "preferred_syntax = :scss\n" +
							"output_style = :expanded\n" +
							"line_comments = true\n"

		#Minify/JS
		uglify:
			coffee:
				options:
					banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
							'<%= grunt.template.today("yyyy-mm-dd") %> */\n'
				src: 'src/js/main.js'
				dest: 'dist/js/main.js'

			vendor:
				src: 'src/js/vendor.js'
				dest: 'dist/js/vendor.js'

		#Minify/CSS
		cssmin:
			options:
				banner: '/* Minified main.css file <%= grunt.template.today("yyyy-mm-dd H:M") %> */'
			main:
				src: 'src/css/main.css'
				dest: 'dist/css/main.css'


		#server
		connect:
			server:
				options:
					hostname: "*"
					port: 9500
					base: 'src'
					livereload: true

		#watch
		watch:
			coffee:
				files: 'src/coffee/**/*.coffee'
				tasks: ['js']
				options:
					livereload: true
			sass:
				files: 'src/scss/**/*.scss'
				tasks: ['css']
				options:
					livereload: true
			html:
				files: 'src/**/*.html'
				options:
					livereload: true

		#distクリア
		clean:
			dist:
				src: ['dist/']

		#staticファイルコピー
		copy:
			dist:
				expand: true
				cwd: 'src/'
				src: [
					'**'
					'!.*'
					'!js/*.map'
					'!css/main.css'
					'!scss/**'
					'!coffee/**'
				]
				dest: 'dist/'
				filter: 'isFile'
			# public:
			# 	expand: true
			# 	cwd: 'dist/'
			# 	src: [
			# 		'**'
			# 		'!.*'
			# 	]
			# 	dest: '../cc/dev/public/'
			# 	filter: 'isFile'


	#デフォルト
	grunt.registerTask 'default', ['build']
	#ビルド
	# grunt.registerTask 'build', ['clean', 'copy', 'css', 'js', 'cssmin', 'uglify:vendor', 'uglify:coffee']
	grunt.registerTask 'build', ['clean', 'css', 'js', 'cssmin','copy:dist']
	#js生成
	grunt.registerTask 'js', ['concat:vendor', 'concat:coffee', 'coffee']
	#css生成
	grunt.registerTask 'css', ['compass']
	#サーバ
	grunt.registerTask 'server', ['css', 'js', 'connect', 'watch']
