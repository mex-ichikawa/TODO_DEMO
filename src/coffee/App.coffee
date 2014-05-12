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
