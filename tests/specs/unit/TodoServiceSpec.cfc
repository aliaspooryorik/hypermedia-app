/**
 * Unit Test for TodoService
 * 
 * BDD Style test that extends the TestBox BaseSpec class.
 * This test focuses on testing the TodoService model in isolation.
 */
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		// Setup the service
		variables.todoService = new root.models.TodoService();
	}

	function afterAll(){
		// Cleanup
		structDelete( variables, "todoService" );
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "TodoService", function(){
			
			describe( "Initialization", function(){
				it( "should initialize with empty todos array", function(){
					var service = new root.models.TodoService();
					expect( service.getTodos() ).toBeArray();
					expect( arrayLen( service.getTodos() ) ).toBe( 0 );
				});

				it( "should populate sample data on DI completion", function(){
					var service = new root.models.TodoService();
					service.onDiComplete();
					expect( arrayLen( service.getTodos() ) ).toBeGT( 0 );
				});
			});

			describe( "Adding todos", function(){
				beforeEach( function(){
					variables.service = new root.models.TodoService();
				});

				it( "should add a todo with default done status as false", function(){
					variables.service.add( "Test task" );
					var todos = variables.service.getTodos();
					
					expect( arrayLen( todos ) ).toBe( 1 );
					expect( todos[1].title ).toBe( "Test task" );
					expect( todos[1].done ).toBeFalse();
					expect( todos[1].id ).toBeString();
					expect( len( todos[1].id ) ).toBeGT( 0 );
				});

				it( "should add a todo with specified done status", function(){
					variables.service.add( "Completed task", true );
					var todos = variables.service.getTodos();
					
					expect( arrayLen( todos ) ).toBe( 1 );
					expect( todos[1].title ).toBe( "Completed task" );
					expect( todos[1].done ).toBeTrue();
				});

				it( "should generate unique IDs for multiple todos", function(){
					variables.service.add( "Task 1" );
					variables.service.add( "Task 2" );
					var todos = variables.service.getTodos();
					
					expect( arrayLen( todos ) ).toBe( 2 );
					expect( todos[1].id ).notToBe( todos[2].id );
				});
			});

			describe( "Listing todos", function(){
				beforeEach( function(){
					variables.service = new root.models.TodoService();
					// Add test data
					variables.service.add( "Alpha task", false );
					variables.service.add( "Beta task", true );
					variables.service.add( "Charlie task", false );
					variables.service.add( "Alpha secondary", true );
				});

				it( "should return all todos when no search filter", function(){
					var result = variables.service.list( 
						search = "",
						limit = 10,
						page = 1,
						sortField = "",
						sortDirection = "asc"
					);
					
					expect( result.totalCount ).toBe( 4 );
					expect( arrayLen( result.data ) ).toBe( 4 );
					expect( result.page ).toBe( 1 );
					expect( result.limit ).toBe( 10 );
				});

				it( "should filter todos by search term", function(){
					var result = variables.service.list( 
						search = "Alpha",
						limit = 10,
						page = 1,
						sortField = "",
						sortDirection = "asc"
					);
					
					expect( result.totalCount ).toBe( 2 );
					expect( arrayLen( result.data ) ).toBe( 2 );
					expect( result.data[1].title ).toMatch( "Alpha" );
					expect( result.data[2].title ).toMatch( "Alpha" );
				});

				it( "should sort todos by title ascending", function(){
					var result = variables.service.list( 
						search = "",
						limit = 10,
						page = 1,
						sortField = "title",
						sortDirection = "asc"
					);
					
					expect( result.data[1].title ).toBe( "Alpha secondary" );
					expect( result.data[2].title ).toBe( "Alpha task" );
					expect( result.data[3].title ).toBe( "Beta task" );
					expect( result.data[4].title ).toBe( "Charlie task" );
				});

				it( "should sort todos by title descending", function(){
					var result = variables.service.list( 
						search = "",
						limit = 10,
						page = 1,
						sortField = "title",
						sortDirection = "desc"
					);
					
					expect( result.data[1].title ).toBe( "Charlie task" );
					expect( result.data[2].title ).toBe( "Beta task" );
					expect( result.data[3].title ).toBe( "Alpha task" );
					expect( result.data[4].title ).toBe( "Alpha secondary" );
				});

				it( "should paginate results correctly", function(){
					var result = variables.service.list( 
						search = "",
						limit = 2,
						page = 1,
						sortField = "title",
						sortDirection = "asc"
					);
					
					expect( result.totalCount ).toBe( 4 );
					expect( arrayLen( result.data ) ).toBe( 2 );
					expect( result.page ).toBe( 1 );
					expect( result.limit ).toBe( 2 );
					expect( result.data[1].title ).toBe( "Alpha secondary" );
					expect( result.data[2].title ).toBe( "Alpha task" );
				});

				it( "should return correct second page", function(){
					var result = variables.service.list( 
						search = "",
						limit = 2,
						page = 2,
						sortField = "title",
						sortDirection = "asc"
					);
					
					expect( result.totalCount ).toBe( 4 );
					expect( arrayLen( result.data ) ).toBe( 2 );
					expect( result.page ).toBe( 2 );
					expect( result.data[1].title ).toBe( "Beta task" );
					expect( result.data[2].title ).toBe( "Charlie task" );
				});

				it( "should handle page beyond available data", function(){
					var result = variables.service.list( 
						search = "",
						limit = 10,
						page = 5,
						sortField = "",
						sortDirection = "asc"
					);
					
					expect( result.totalCount ).toBe( 4 );
					expect( arrayLen( result.data ) ).toBe( 0 );
					expect( result.page ).toBe( 5 );
				});
			});

			describe( "Finding todos by ID", function(){
				beforeEach( function(){
					variables.service = new root.models.TodoService();
					variables.service.add( "Test task" );
					variables.testId = variables.service.getTodos()[1].id;
				});

				it( "should find existing todo by ID", function(){
					var todo = variables.service.findById( variables.testId );
					
					expect( todo ).toBeStruct();
					expect( todo.id ).toBe( variables.testId );
					expect( todo.title ).toBe( "Test task" );
					expect( todo.done ).toBeFalse();
				});

				it( "should return empty struct for non-existent ID", function(){
					var todo = variables.service.findById( "non-existent-id" );
					
					expect( todo ).toBeStruct();
					expect( structIsEmpty( todo ) ).toBeTrue();
				});
			});

			describe( "Updating todos", function(){
				beforeEach( function(){
					variables.service = new root.models.TodoService();
					variables.service.add( "Original task", false );
					variables.testId = variables.service.getTodos()[1].id;
				});

				it( "should update existing todo title and status", function(){
					var result = variables.service.update( variables.testId, "Updated task", true );
					var todo = variables.service.findById( variables.testId );
					
					expect( result ).toBeTrue();
					expect( todo.title ).toBe( "Updated task" );
					expect( todo.done ).toBeTrue();
				});

				it( "should update existing todo with default done status", function(){
					var result = variables.service.update( variables.testId, "Updated task" );
					var todo = variables.service.findById( variables.testId );
					
					expect( result ).toBeTrue();
					expect( todo.title ).toBe( "Updated task" );
					expect( todo.done ).toBeFalse();
				});

				it( "should return false for non-existent todo", function(){
					var result = variables.service.update( "non-existent-id", "Updated task", true );
					
					expect( result ).toBeFalse();
				});
			});

			describe( "Toggling todo status", function(){
				beforeEach( function(){
					variables.service = new root.models.TodoService();
					variables.service.add( "Test task", false );
					variables.testId = variables.service.getTodos()[1].id;
				});

				it( "should toggle done status from false to true", function(){
					var result = variables.service.toggleDone( variables.testId );
					var todo = variables.service.findById( variables.testId );
					
					expect( result ).toBeTrue();
					expect( todo.done ).toBeTrue();
				});

				it( "should toggle done status from true to false", function(){
					// First toggle to true
					variables.service.toggleDone( variables.testId );
					// Then toggle back to false
					var result = variables.service.toggleDone( variables.testId );
					var todo = variables.service.findById( variables.testId );
					
					expect( result ).toBeTrue();
					expect( todo.done ).toBeFalse();
				});

				it( "should return false for non-existent todo", function(){
					var result = variables.service.toggleDone( "non-existent-id" );
					
					expect( result ).toBeFalse();
				});
			});

			describe( "Deleting todos", function(){
				beforeEach( function(){
					variables.service = new root.models.TodoService();
					variables.service.add( "Task to delete" );
					variables.service.add( "Task to keep" );
					variables.deleteId = variables.service.getTodos()[1].id;
					variables.keepId = variables.service.getTodos()[2].id;
				});

				it( "should delete existing todo", function(){
					var result = variables.service.delete( variables.deleteId );
					var todos = variables.service.getTodos();
					
					expect( result ).toBeTrue();
					expect( arrayLen( todos ) ).toBe( 1 );
					expect( todos[1].id ).toBe( variables.keepId );
					expect( todos[1].title ).toBe( "Task to keep" );
				});

				it( "should return false for non-existent todo", function(){
					var result = variables.service.delete( "non-existent-id" );
					var todos = variables.service.getTodos();
					
					expect( result ).toBeFalse();
					expect( arrayLen( todos ) ).toBe( 2 );
				});

				it( "should handle deleting all todos", function(){
					variables.service.delete( variables.deleteId );
					var result = variables.service.delete( variables.keepId );
					var todos = variables.service.getTodos();
					
					expect( result ).toBeTrue();
					expect( arrayLen( todos ) ).toBe( 0 );
				});
			});

			describe( "Edge cases and error handling", function(){
				beforeEach( function(){
					variables.service = new root.models.TodoService();
				});

				it( "should handle empty search string", function(){
					variables.service.add( "Test task" );
					var result = variables.service.list( 
						search = "",
						limit = 10,
						page = 1,
						sortField = "",
						sortDirection = "asc"
					);
					
					expect( arrayLen( result.data ) ).toBe( 1 );
				});

				it( "should handle zero limit gracefully", function(){
					variables.service.add( "Test task" );
					var result = variables.service.list( 
						search = "",
						limit = 0,
						page = 1,
						sortField = "",
						sortDirection = "asc"
					);
					
					expect( arrayLen( result.data ) ).toBe( 0 );
					expect( result.totalCount ).toBe( 1 );
					expect( result.limit ).toBe( 0 );
				});

				it( "should handle case insensitive search", function(){
					variables.service.add( "Alpha Task" );
					var result = variables.service.list( 
						search = "alpha",
						limit = 10,
						page = 1,
						sortField = "",
						sortDirection = "asc"
					);
					
					expect( arrayLen( result.data ) ).toBe( 1 );
					expect( result.data[1].title ).toBe( "Alpha Task" );
				});
			});
		});
	}
}
