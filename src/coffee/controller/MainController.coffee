#ログインページビュー
namespace "controller", -> class MainController
	constructor: (@$scope, @$location) ->
		$scope.todoSubmit = @_addTodo
		$scope.changeTodo = @_changeTodo
		$scope.deleteTodo = @_deleteTodo
		$scope.todoList = []
		@_todoList = []
		@_getTodos()
		return
	#指定オブジェクト取得
	_getModelById: (id) =>
		for item in @_todoList
			if item.id is id
				return item
		return null

	#追加
	_addTodo: (e) =>
		e.preventDefault()
		todo = new Todo()
		todo.set(Todo.TEXT, @$scope.todoText)
		todo.set(Todo.IS_ACTIVE, true)
		todo.save().then(
			(obj)=>
				@$scope.$apply =>
					@$scope.todoText = ""
					@_getTodos()
				return
			(error) =>
				console.log "failed"
				return
		)
		return false
	#更新
	_changeTodo: (e) =>
		item = @_getModelById(e.target.value)
		if item
			item.set(Todo.IS_ACTIVE, !item.get(Todo.IS_ACTIVE))
			item.save().then(
				(obj)=>
					@_getTodos()
					return
				(error) =>
					console.log "failed"
					return
			)
		return
	#削除
	_deleteTodo: (e, id) =>
		e.preventDefault()
		item = @_getModelById(id)
		if item
			item.destroy().then(
				(obj) =>
					@_getTodos()
					return
				(obj, error) =>
					console.log "failed"
					return
			)
		return
	#リスト取得
	_getTodos: =>
		query = new Parse.Query(Todo)
		query.descending(Todo.UPDATED_AT)
		query.find().then(
			(results)=>
				arr = []
				@_todoList = results
				for result in results
					arr.push {
						id: result.id
						text: result.get(Todo.TEXT)
						isActive: result.get(Todo.IS_ACTIVE)
					}
				@$scope.$apply =>
					@$scope.todoList = arr
				return
			(error) =>
				@$scope.$apply =>
					@$scope.todoList = []
				return
		)
		return
