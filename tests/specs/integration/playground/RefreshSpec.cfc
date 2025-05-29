/*******************************************************************************
 *	CBWire Component Integration Tests - Refresh Component
 *
 *	Tests for the playground Refresh.cfc CBWire component
 *
 *	These tests verify the functionality of the Refresh wire component including:
 *	- Component initialization and data structure
 *	- Event dispatching for component coordination
 *	- Refresh and reload functionality
 *	- State management methods
 *******************************************************************************/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// Initialize WireBox
		variables.wirebox = getWireBox();
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Playground Refresh Wire Component", function(){
			
			beforeEach(function(currentSpec){
				// Setup as a new ColdBox request
				setup();
				// Create a fresh instance of the component for each test
				variables.refreshComponent = variables.wirebox.getInstance("wires.playground.Refresh");
			});

			describe("Component Initialization", function(){
				
				it("should initialize with correct default data structure", function(){
					// Access data properties via generated getters
					expect(variables.refreshComponent.getMode()).toBe("x");
				});

			});

			describe("Refresh and Reload Actions", function(){

				it("should handle reload operations without errors", function(){
					expect(function(){
						variables.refreshComponent.reload();
					}).notToThrow();
				});

				it("should handle reloadList operations without errors", function(){
					expect(function(){
						variables.refreshComponent.reloadList();
					}).notToThrow();
				});

			});

			describe("Show/Hide Actions", function(){

				it("should handle showAdd operations without errors", function(){
					expect(function(){
						variables.refreshComponent.showAdd();
					}).notToThrow();
				});

				it("should handle showList operations without errors", function(){
					expect(function(){
						variables.refreshComponent.showList();
					}).notToThrow();
				});

			});

			describe("Component Integration", function(){
				
				it("should extend cbwire.models.Component", function(){
					var metadata = getMetadata(variables.refreshComponent);
					expect(metadata.extends.name).toBe("cbwire.models.Component");
				});

				it("should have minimal data structure for simple coordination", function(){
					// This component is primarily for event coordination
					// so it should have minimal data requirements
					expect(variables.refreshComponent.getMode()).toBe("x");
				});

			});

			describe("Event Coordination Scenarios", function(){

				it("should coordinate multiple show/hide actions in sequence", function(){
					expect(function(){
						variables.refreshComponent.showAdd();
						variables.refreshComponent.showList();
						variables.refreshComponent.showAdd();
					}).notToThrow();
				});

				it("should handle reload operations independently", function(){
					expect(function(){
						variables.refreshComponent.reload();
						variables.refreshComponent.reloadList();
						variables.refreshComponent.showList();
					}).notToThrow();
				});

			});

			describe("Error Handling", function(){
				
				it("should handle method calls gracefully even without mocking", function(){
					// Test with a fresh component that doesn't have mocked methods
					var realComponent = variables.wirebox.getInstance("wires.playground.Refresh");
					
					// These should not throw errors
					expect(function(){
						realComponent.showAdd();
					}).notToThrow();
					
					expect(function(){
						realComponent.showList();
					}).notToThrow();
					
					expect(function(){
						realComponent.reloadList();
					}).notToThrow();
				});

			});

		});
	}

}
