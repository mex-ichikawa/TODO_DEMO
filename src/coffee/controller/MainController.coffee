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
