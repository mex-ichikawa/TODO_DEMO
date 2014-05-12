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

