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
