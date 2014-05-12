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
