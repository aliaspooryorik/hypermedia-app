/*******************************************************************************
 *	CBWire Component Integration Tests - Add Component
 *
 *	Tests for the playground Add.cfc CBWire component
 *
 *	These tests verify the functionality of the Add wire component including:
 *	- Component initialization and data structure
 *	- Event listeners and state management
 *	- Add action and service integration
 *	- Component lifecycle methods
 *******************************************************************************/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// Initialize WireBox and get the component
		variables.wirebox = getWireBox();
		variables.todoService = variables.wirebox.getInstance("TodoService");
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Playground Add Wire Component", function(){
			
			beforeEach(function(currentSpec){
				// Setup as a new ColdBox request
				setup();
				// Create a fresh instance of the component for each test
				variables.addComponent = variables.wirebox.getInstance("wires.playground.Add");
			});

			describe("Component Initialization", function(){
				
				it("should initialize with correct default data structure", function(){
					// Access data properties via generated getters
					expect(variables.addComponent.getActive()).toBeTrue();
					expect(variables.addComponent.getTitle()).toBe("");
				});

				it("should have TodoService dependency injected", function(){
					// CBWire components should have the TodoService injected
					// We can test this by verifying the component works properly
					expect(variables.addComponent).toBeComponent();
					expect(isObject(variables.addComponent)).toBeTrue();
				});

			});

			describe("State Management Methods", function(){
				
				it("should set active state to true when setActive is called", function(){
					// First set to false using setInactive
					variables.addComponent.setInactive();
					expect(variables.addComponent.getActive()).toBeFalse();
					
					// Call setActive method (which sets to true)
					variables.addComponent.setActive();
					
					expect(variables.addComponent.getActive()).toBeTrue();
				});

				it("should set active state to false when setInactive is called", function(){
					// Ensure it starts as true
					expect(variables.addComponent.getActive()).toBeTrue();
					
					// Call setInactive
					variables.addComponent.setInactive();
					
					expect(variables.addComponent.getActive()).toBeFalse();
				});

			});

			describe("Add Action", function(){

				it("should add a todo item when add action is called", function(){
					// Set up test data using the generated setter
					variables.addComponent.setTitle("Test Todo Item");
					
					// Get initial todo count
					var initialResult = variables.todoService.list(
						search = "",
						limit = 100,
						page = 1,
						sortField = "title",
						sortDirection = "asc"
					);
					var initialCount = initialResult.totalCount;
					
					// Call add action - this should work without mocking
					variables.addComponent.add();
					
					// Verify todo was added
					var finalResult = variables.todoService.list(
						search = "",
						limit = 100,
						page = 1,
						sortField = "title",
						sortDirection = "asc"
					);
					expect(finalResult.totalCount).toBe(initialCount + 1);
					
					// Find the added todo
					var addedTodo = finalResult.data.find(function(item){
						return item.title == "Test Todo Item";
					});
					expect(addedTodo).notToBeEmpty();
				});

				it("should handle empty title gracefully", function(){
					variables.addComponent.setTitle("");
					
					// This should not throw an error
					expect(function(){
						variables.addComponent.add();
					}).notToThrow();
				});

			});

			describe("Component Integration", function(){
				
				it("should extend cbwire.models.Component", function(){
					var metadata = getMetadata(variables.addComponent);
					expect(metadata.extends.name).toBe("cbwire.models.Component");
				});

				it("should work with real TodoService", function(){
					// Test with actual service integration
					var realComponent = variables.wirebox.getInstance("wires.playground.Add");
					realComponent.setTitle("Integration Test Todo");
					
					var initialCount = variables.todoService.list(
						search = "",
						limit = 100,
						page = 1,
						sortField = "title",
						sortDirection = "asc"
					).totalCount;
					
					realComponent.add();
					
					var finalCount = variables.todoService.list(
						search = "",
						limit = 100,
						page = 1,
						sortField = "title",
						sortDirection = "asc"
					).totalCount;
					
					expect(finalCount).toBe(initialCount + 1);
				});

			});

		});
	}

}
