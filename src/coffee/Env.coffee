##### 実行環境環境 #####
Env =
	#デバッグモード on/off
	IS_DEBUG: true

	#モバイルかかどうか
	IS_MOBILE: !!(navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/))

	#環境言語
	LANG: (navigator?.browserLanguage ? navigator?.language ? navigator?.userLanguage)?.substr?(0,2) ? "en"