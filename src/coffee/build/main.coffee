##### 実行環境環境 #####
Env =
	#デバッグモード on/off
	IS_DEBUG: true

	#モバイルかかどうか
	IS_MOBILE: !!(navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/))

	#環境言語
	LANG: (navigator?.browserLanguage ? navigator?.language ? navigator?.userLanguage)?.substr?(0,2) ? "en"
if Env.IS_DEBUG
	Config =
		PARSE_APPLICATION_ID: '<PARSE_APPLICATION_ID_DEV>'
		PARSE_REST_API_KEY: '<PARSE_REST_API_KEY_DEV>'
		# FACEBOOK_APP_ID: '<FACEBOOK_APP_ID_DEV>'
else
	Config =
		PARSE_APPLICATION_ID: '<PARSE_APPLICATION_ID>'
		PARSE_REST_API_KEY: '<PARSE_REST_API_KEY>'
		# FACEBOOK_APP_ID: '<FACEBOOK_APP_ID_DEV>'

##### 実行環境環境 #####
Lang =
	#English
	"en":
		#Global
		"now_loading": "Now Loading…"
	
	#日本語
	"ja":
		#Global
		"now_loading": "よみこみちゅう…"






##### グローバル拡張 #####
# Setter/Getter
Function::define = (prop, desc) ->
	Object.defineProperty @prototype, prop, desc

# Console Safety
unless Env?.IS_DEBUG
	for key,val of console
		console[key] = -> return


##### グローバル関数 #####

###*
* 名前空間実装
* @param {String} カンマ区切りのパッケージ文字列
* @param {Function} クラス内包の無名関数
###
namespace = (namespace, fn) ->
	klass = fn()
	here = @
	if namespace
		tokens = namespace.split('.')
		for token in tokens
			if token
				here[token] ?= {}
				here = here[token]
	name = klass.name ? klass.toString().match(/^function\s*([^\s(]+)/)[1];
	here[name] = klass
	return

###*
* i18n実装
* @param {String} 取得文字のキー
* @param {String} 説明
###
__ = (key, summary = "") ->
	lang = Env.LANG
	if lang of Lang
		if key of Lang[lang]
			return Lang[lang][key]
	return key

###*
* コンストラクタに可変引数の受け渡しをする
* @param {Function} クラス
* @param {Array} 引数の配列
* @return {Any} 与えられたクラスのインスタンス
###
construct = (constructor, args) ->
	F = ->
		return constructor.apply @, args
	F:: = constructor::
	return new F()

###*
* 遅延実行
* @param {Number} 遅延時間(ミリ秒)
* @param {Function} 実行関数
* @return {Number} Timer ID
###
delay = (ms, func) -> setTimeout func, ms

class ParseUtil
	_instance = null
	class PrivateClass
		constructor:(appId, apiKey) ->
			#Parseイニシャライズ
			Parse.initialize(appId, apiKey)
			return

		setFBInit: (appId) =>
			#イベント登録
			window.fbAsyncInit = ->
				Parse.FacebookUtils.init {
					appId      : appId #Facebook App ID
					# channelUrl : '//WWW.YOUR_DOMAIN.COM/channel.html' #Channel File
					# status     : true #check login status
					cookie     : true #enable cookies to allow Parse to access the session
					xfbml      : true #parse XFBML
				}
			#スクリプト読み込み
			unless document.getElementById('facebook-jssdk')
				firstScriptElement = document.getElementsByTagName('script')[0]
				facebookJS = document.createElement('script')
				facebookJS.id = 'facebook-jssdk'
				facebookJS.src = '//connect.facebook.net/en_US/all.js'
				firstScriptElement.parentNode.insertBefore(facebookJS, firstScriptElement)
			return

	@getInstance: (appId, apiKey) ->
		_instance ?= new PrivateClass(appId, apiKey)


#Parseイニシャライズ
parseUtil = ParseUtil.getInstance(Config.PARSE_APPLICATION_ID, Config.PARSE_REST_API_KEY)
# parseUtil.setFBInit(Config.FACEBOOK_APP_ID)

#アプリ取得
App = angular.module('MainApp', ['ngRoute', 'ui.bootstrap'])

#設定ブロック
App.config ($routeProvider, $compileProvider) ->
	#URLのホワイトリスト
	$compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|file|tel):/)
	#ルーティング設定
	$routeProvider
		.when('/', {
			controller: controller.MainController
			templateUrl: 'partials/main.html'
		})
		.otherwise({redirectTo: '/'})
	return

#実行ブロック
App.run ($rootScope, $location) ->
	$rootScope.$on '$routeChangeStart', (event, next, current) ->
		#View切り替え開始時にフック
		return
	return

#ログインページビュー
namespace "controller", -> class MainController
	constructor: (@$scope, @$location) ->
		$scope.name = "Angular.js"
		$scope.count = 0
		$scope.countUp = @_countUpHandler
		return

	_countUpHandler: (e) =>
		@$scope.count += 1
		return

Sample = Parse.Object.extend("Sample")

namespace "", -> class Main
	constructor: ->
		@bindEvents()
		return

	bindEvents: =>
		if Env.IS_MOBILE
			document.addEventListener('deviceready', @onDeviceReady, true)
		else
			@onDeviceReady()
		return

	onDeviceReady: =>
		angular.element(document).ready ->
			angular.bootstrap(document, ['MainApp'])
		return
