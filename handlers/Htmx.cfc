component extends="coldbox.system.EventHandler" {

	property name="TodoService" inject;

	
	/**
	 * Default Action
	 */
	function index( event, rc, prc ){
		// Initialize pagination and search parameters
		param rc.page = 1;
		param rc.limit = 10;
		param rc.search = "";
		param rc.sortField = "title";
		param rc.sortDirection = "asc";

		// Get todo list
		var result = TodoService.list(
			search = rc.search,
			limit = rc.limit,
			page = rc.page,
			sortField = rc.sortField,
			sortDirection = rc.sortDirection
		);

		prc.todos = result.data;
		prc.totalCount = result.totalCount;
		prc.currentPage = result.page;
		prc.totalPages = ceiling(result.totalCount / result.limit);
		prc.limit = result.limit;
		prc.search = rc.search;
		prc.sortField = rc.sortField;
		prc.sortDirection = rc.sortDirection;

		event.setView( "htmx/index" );
	}

	/**
	 * Add a new todo item
	 */
	function add( event, rc, prc ){
		param rc.title = "";
		
		if ( len(trim(rc.title)) ) {
			TodoService.add( rc.title );
		}

		// Return updated todo list
		relocate( "htmx.list" );
	}

	/**
	 * Get todo list (used for HTMX partial updates)
	 */
	function list( event, rc, prc ){
		// Initialize pagination and search parameters
		param rc.page = 1;
		param rc.limit = 10;
		param rc.search = "";
		param rc.sortField = "title";
		param rc.sortDirection = "asc";

		// Get todo list
		var result = TodoService.list(
			search = rc.search,
			limit = rc.limit,
			page = rc.page,
			sortField = rc.sortField,
			sortDirection = rc.sortDirection
		);

		prc.todos = result.data;
		prc.totalCount = result.totalCount;
		prc.currentPage = result.page;
		prc.totalPages = ceiling(result.totalCount / result.limit);
		prc.limit = result.limit;
		prc.search = rc.search;
		prc.sortField = rc.sortField;
		prc.sortDirection = rc.sortDirection;

		event.setView( "htmx/todoList" );
	}

	/**
	 * Delete a todo item
	 */
	function delete( event, rc, prc ){
		param rc.id = "";
		
		if ( len(rc.id) ) {
			TodoService.delete( rc.id );
		}

		// Return updated todo list
		relocate( "htmx.list" );
	}

	/**
	 * Toggle todo done status
	 */
	function toggle( event, rc, prc ){
		param rc.id = "";
		
		if ( len(rc.id) ) {
			TodoService.toggleDone( rc.id );
		}

		// Return updated todo list
		relocate( "htmx.list" );
	}

	/**
	 * Get edit form for a todo item
	 */
	function editForm( event, rc, prc ){
		param rc.id = "";
		
		if ( len(rc.id) ) {
			prc.todo = TodoService.findById( rc.id );
		} else {
			prc.todo = {};
		}

		event.setView( "htmx/editForm" );
	}

	/**
	 * Update a todo item
	 */
	function update( event, rc, prc ){
		param rc.id = "";
		param rc.title = "";
		param rc.done = false;
		
		if ( len(rc.id) && len(trim(rc.title)) ) {
			TodoService.update( rc.id, rc.title, rc.done );
		}

		// Return updated todo list
		relocate( "htmx.list" );
	}

}
