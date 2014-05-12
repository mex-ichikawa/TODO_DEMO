(function() {
  var App, Config, Env, Lang, ParseUtil, Sample, construct, delay, key, namespace, parseUtil, val, __, _ref, _ref1, _ref2, _ref3,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Env = {
    IS_DEBUG: true,
    IS_MOBILE: !!(navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/)),
    LANG: (_ref = (_ref1 = (_ref2 = (_ref3 = typeof navigator !== "undefined" && navigator !== null ? navigator.browserLanguage : void 0) != null ? _ref3 : typeof navigator !== "undefined" && navigator !== null ? navigator.language : void 0) != null ? _ref2 : typeof navigator !== "undefined" && navigator !== null ? navigator.userLanguage : void 0) != null ? typeof _ref1.substr === "function" ? _ref1.substr(0, 2) : void 0 : void 0) != null ? _ref : "en"
  };

  if (Env.IS_DEBUG) {
    Config = {
      PARSE_APPLICATION_ID: '<PARSE_APPLICATION_ID_DEV>',
      PARSE_REST_API_KEY: '<PARSE_REST_API_KEY_DEV>'
    };
  } else {
    Config = {
      PARSE_APPLICATION_ID: '<PARSE_APPLICATION_ID>',
      PARSE_REST_API_KEY: '<PARSE_REST_API_KEY>'
    };
  }

  Lang = {
    "en": {
      "now_loading": "Now Loading…"
    },
    "ja": {
      "now_loading": "よみこみちゅう…"
    }
  };

  Function.prototype.define = function(prop, desc) {
    return Object.defineProperty(this.prototype, prop, desc);
  };

  if (!(Env != null ? Env.IS_DEBUG : void 0)) {
    for (key in console) {
      val = console[key];
      console[key] = function() {};
    }
  }


  /**
  * 名前空間実装
  * @param {String} カンマ区切りのパッケージ文字列
  * @param {Function} クラス内包の無名関数
   */

  namespace = function(namespace, fn) {
    var here, klass, name, token, tokens, _i, _len, _ref4;
    klass = fn();
    here = this;
    if (namespace) {
      tokens = namespace.split('.');
      for (_i = 0, _len = tokens.length; _i < _len; _i++) {
        token = tokens[_i];
        if (token) {
          if (here[token] == null) {
            here[token] = {};
          }
          here = here[token];
        }
      }
    }
    name = (_ref4 = klass.name) != null ? _ref4 : klass.toString().match(/^function\s*([^\s(]+)/)[1];
    here[name] = klass;
  };


  /**
  * i18n実装
  * @param {String} 取得文字のキー
  * @param {String} 説明
   */

  __ = function(key, summary) {
    var lang;
    if (summary == null) {
      summary = "";
    }
    lang = Env.LANG;
    if (lang in Lang) {
      if (key in Lang[lang]) {
        return Lang[lang][key];
      }
    }
    return key;
  };


  /**
  * コンストラクタに可変引数の受け渡しをする
  * @param {Function} クラス
  * @param {Array} 引数の配列
  * @return {Any} 与えられたクラスのインスタンス
   */

  construct = function(constructor, args) {
    var F;
    F = function() {
      return constructor.apply(this, args);
    };
    F.prototype = constructor.prototype;
    return new F();
  };


  /**
  * 遅延実行
  * @param {Number} 遅延時間(ミリ秒)
  * @param {Function} 実行関数
  * @return {Number} Timer ID
   */

  delay = function(ms, func) {
    return setTimeout(func, ms);
  };

  ParseUtil = (function() {
    var PrivateClass, _instance;

    function ParseUtil() {}

    _instance = null;

    PrivateClass = (function() {
      function PrivateClass(appId, apiKey) {
        this.setFBInit = __bind(this.setFBInit, this);
        Parse.initialize(appId, apiKey);
        return;
      }

      PrivateClass.prototype.setFBInit = function(appId) {
        var facebookJS, firstScriptElement;
        window.fbAsyncInit = function() {
          return Parse.FacebookUtils.init({
            appId: appId,
            cookie: true,
            xfbml: true
          });
        };
        if (!document.getElementById('facebook-jssdk')) {
          firstScriptElement = document.getElementsByTagName('script')[0];
          facebookJS = document.createElement('script');
          facebookJS.id = 'facebook-jssdk';
          facebookJS.src = '//connect.facebook.net/en_US/all.js';
          firstScriptElement.parentNode.insertBefore(facebookJS, firstScriptElement);
        }
      };

      return PrivateClass;

    })();

    ParseUtil.getInstance = function(appId, apiKey) {
      return _instance != null ? _instance : _instance = new PrivateClass(appId, apiKey);
    };

    return ParseUtil;

  })();

  parseUtil = ParseUtil.getInstance(Config.PARSE_APPLICATION_ID, Config.PARSE_REST_API_KEY);

  App = angular.module('MainApp', ['ngRoute', 'ui.bootstrap']);

  App.config(function($routeProvider, $compileProvider) {
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|file|tel):/);
    $routeProvider.when('/', {
      controller: controller.MainController,
      templateUrl: 'partials/main.html'
    }).otherwise({
      redirectTo: '/'
    });
  });

  App.run(function($rootScope, $location) {
    $rootScope.$on('$routeChangeStart', function(event, next, current) {});
  });

  namespace("controller", function() {
    var MainController;
    return MainController = (function() {
      function MainController($scope, $location) {
        this.$scope = $scope;
        this.$location = $location;
        $scope.name = "Angular.js";
        return;
      }

      return MainController;

    })();
  });

  Sample = Parse.Object.extend("Sample");

  namespace("", function() {
    var Main;
    return Main = (function() {
      function Main() {
        this.onDeviceReady = __bind(this.onDeviceReady, this);
        this.bindEvents = __bind(this.bindEvents, this);
        this.bindEvents();
        return;
      }

      Main.prototype.bindEvents = function() {
        if (Env.IS_MOBILE) {
          document.addEventListener('deviceready', this.onDeviceReady, true);
        } else {
          this.onDeviceReady();
        }
      };

      Main.prototype.onDeviceReady = function() {
        angular.element(document).ready(function() {
          return angular.bootstrap(document, ['MainApp']);
        });
      };

      return Main;

    })();
  });

}).call(this);

//# sourceMappingURL=main.js.map
