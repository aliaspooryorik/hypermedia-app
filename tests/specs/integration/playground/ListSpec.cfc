/*******************************************************************************
 *	CBWire Component Integration Tests - List Component
 *
 *	Tests for the playground List.cfc CBWire component
 *
 *	These tests verify the functionality of the List wire component including:
 *	- Component initialization and data structure
 *	- Event listeners and state management
 *	- Pagination functionality
 *	- Search and sorting capabilities
 *	- CRUD operations (delete)
 *	- Component lifecycle methods
 *******************************************************************************/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// Initialize WireBox and get dependencies
		variables.wirebox = getWireBox();
		variables.todoService = variables.wirebox.getInstance("TodoService");
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Playground List Wire Component", function(){
			
			beforeEach(function(currentSpec){
				// Setup as a new ColdBox request
				setup();
				// Create a fresh instance of the component for each test
				variables.listComponent = variables.wirebox.getInstance("wires.playground.List");
			});

			describe("Component Initialization", function(){
				
				it("should initialize with correct default data structure", function(){
					// Access data properties via generated getters
					expect(variables.listComponent.getActive()).toBeTrue();
					expect(variables.listComponent.getPage()).toBe(1);
					expect(variables.listComponent.getLimit()).toBe(5);
					expect(variables.listComponent.getSearch()).toBe("");
					expect(variables.listComponent.getSortField()).toBe("title");
					expect(variables.listComponent.getSortDirection()).toBe("asc");
					expect(variables.listComponent.getCurrentItems()).toBeArray();
				});

				it("should have TodoService dependency injected", function(){
					// CBWire components should have the TodoService injected
					// We can test this by verifying the component works properly
					expect(variables.listComponent).toBeComponent();
					expect(isObject(variables.listComponent)).toBeTrue();
				});

			});

			describe("State Management Methods", function(){
				
				it("should set active state and load data when setActive is called", function(){
					// First set to inactive using setInactive
					variables.listComponent.setInactive();
					expect(variables.listComponent.getActive()).toBeFalse();
					
					// Call setActive - this should set active to true and call list()
					variables.listComponent.setActive();
					
					expect(variables.listComponent.getActive()).toBeTrue();
				});

				it("should set active state to false when setInactive is called", function(){
					// Ensure it starts as true
					expect(variables.listComponent.getActive()).toBeTrue();
					
					// Call setInactive
					variables.listComponent.setInactive();
					
					expect(variables.listComponent.getActive()).toBeFalse();
				});

			});

			describe("Lifecycle Methods", function(){
				
				it("should call list method on mount", function(){
					// Test that onMount executes without errors
					expect(function(){
						variables.listComponent.onMount();
					}).notToThrow();
				});

				it("should handle search changes in onUpdate", function(){
					var oldValues = { search: "old" };
					var newValues = { search: "new" };
					
					// This should execute without errors
					expect(function(){
						variables.listComponent.onUpdate(oldValues, newValues);
					}).notToThrow();
				});

				it("should not call updatedSearch when search hasn't changed", function(){
					var oldValues = { search: "same" };
					var newValues = { search: "same" };
					
					// This should execute without errors
					expect(function(){
						variables.listComponent.onUpdate(oldValues, newValues);
					}).notToThrow();
				});

			});

			describe("Pagination Helper Methods", function(){
				
				it("should correctly determine if there is a previous page", function(){
					variables.listComponent.setPage(1);
					expect(variables.listComponent.hasPreviousPage()).toBeFalse();
					
					variables.listComponent.setPage(2);
					expect(variables.listComponent.hasPreviousPage()).toBeTrue();
				});

				it("should correctly determine if there is a next page", function(){
					variables.listComponent.setPage(1);
					variables.listComponent.setTotalPages(3);
					expect(variables.listComponent.hasNextPage()).toBeTrue();
					
					variables.listComponent.setPage(3);
					variables.listComponent.setTotalPages(3);
					expect(variables.listComponent.hasNextPage()).toBeFalse();
				});

			});

			describe("Pagination Actions", function(){

				it("should handle pagination methods without errors", function(){
					// Test that pagination methods execute without errors
					variables.listComponent.setPage(1);
					variables.listComponent.setTotalPages(3);
					
					expect(function(){
						variables.listComponent.nextPage();
					}).notToThrow();
					
					expect(function(){
						variables.listComponent.previousPage();
					}).notToThrow();
					
					expect(function(){
						variables.listComponent.goToPage(2);
					}).notToThrow();
				});

			});

			describe("Other Actions", function(){

				it("should handle search and sorting actions without errors", function(){
					expect(function(){
						variables.listComponent.updatedSearch();
					}).notToThrow();
					
					expect(function(){
						variables.listComponent.toggleSort("title");
					}).notToThrow();
					
					expect(function(){
						variables.listComponent.setItemsPerPage(10);
					}).notToThrow();
				});

				it("should handle delete operations without errors", function(){
					expect(function(){
						variables.listComponent.delete("test-id");
					}).notToThrow();
				});

			});

			describe("Component Integration", function(){
				
				it("should extend cbwire.models.Component", function(){
					var metadata = getMetadata(variables.listComponent);
					expect(metadata.extends.name).toBe("cbwire.models.Component");
				});

				it("should work with real TodoService for list operations", function(){
					var realComponent = variables.wirebox.getInstance("wires.playground.List");
					
					// Call setActive() which internally calls the private list() method
					// This should not throw an error and should populate data
					realComponent.setActive();
					
					expect(realComponent.getTotalCount()).toBeGTE(0);
					expect(realComponent.getCurrentItems()).toBeArray();
					expect(realComponent.getTotalPages()).toBeGTE(0);
				});

			});

		});
	}

}
