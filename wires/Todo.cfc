// ./wires/Counter.cfc
component extends="cbwire.models.Component" {
    
    property name="TodoService" inject;

    data = {
        "page"  : 1,
        "limit" : 5,
        "title": "",
        "search": "",
        "sortField": "title",
        "sortDirection": "asc",
        "totalCount": 0,
        "totalPages": 0,
        "currentCount": 0,
        "currentItems": [],
        "editingId": "",
        "editTitle": "",
        "editDone": false,
        "toastMessage": ""
    };

    /**
     * fires when first mounted before any data is rendered
     * @param params - any initial data for the component
     */
    function onMount(  event, rc, prc, params ) {
        // Initialize data on mount
        sleep(1000) // Simulate a delay for loading
        list();
    }

    /**
     * shown while the component is mounted
     */
    function placeholder() {
        return "<div>Loading...</div>";
    }

    /**
     * fires when data changes, does not cause a re-render
     * @param oldvalues - the old values of the data
     * @param newvalues - the new values of the data
     */
    function onUpdate( oldvalues, newvalues ) {
        if ( oldvalues.search != newvalues.search ) {
            updatedSearch();
        }
    }
    
    // Action - loads current page items and sets total count
    private function list() {
        var result = TodoService.list(
            search = data.search,
            limit = data.limit,
            page = data.page,
            sortField = data.sortField,
            sortDirection = data.sortDirection
        );
        data.totalCount = result.totalCount;
        data.currentCount = result.data.len();
        data.currentItems = result.data;
        data.totalPages = ceiling(data.totalCount / data.limit);
    }

    // VIEW HELPERS....

    /**
     * Check if we have a previous page
     */
    boolean function hasPreviousPage() {
        return data.page > 1;
    }

    /**
     * Check if we have a next page
     */
    boolean function hasNextPage() {
        return data.page < data.totalPages;
    }

    // ACTIONS....
    
    /**
     * Toggle sort field and direction
     */
    void function toggleSort(required string field) {
        if (data.sortField == field) {
            // Same field - toggle direction
            data.sortDirection = (data.sortDirection == "asc") ? "desc" : "asc";
        } else {
            // Different field - set new field and default to ascending
            data.sortField = field;
            data.sortDirection = "asc";
        }
        list();
    }
    
    void function nextPage() {
        if (hasNextPage()) {
            data.page++;
            list();
        }
    }
    void function previousPage() {
        if (hasPreviousPage()) {
            data.page--;
            list();
        }
    }

    void function goToPage(required numeric page) {
        var totalPages = data.totalPages;
        if (page >= 1 && page <= totalPages) {
            data.page = page;
            list();
        }
    }

    // Set items per page and reset to first page
    void function setItemsPerPage(required numeric size) {
        data.limit = size;
        data.page = 1; // Reset to first page when changing items per page
        list();
    }

    // Reset pagination when search changes
    void function updatedSearch() {
        cancelEdit(); // Clear any active editing state when searching
        data.page = 1;
        list();
    }

    void function add( ) {
        TodoService.add( data.title );
        reset();
        cancelEdit(); // Clear any active editing state
        data.page = 1; // Reset to first page after adding
        data.toastMessage = "Todo item added successfully!";
        list();
    }

    void function delete( required id ) {
        sleep( 500 ); // Simulate a delay for the delete operation
        TodoService.delete( id );
        data.toastMessage = "Todo item deleted successfully!";
        // Check if current page is empty after deletion
        if (arrayLen(data.currentItems) == 0 && data.page > 1) {
            data.page--;
        }
        list();
    }

    // EDIT ACTIONS....
    
    /**
     * Start editing a todo item
     */
    void function startEdit(required string id) {
        // Find the todo item to edit
        var todo = TodoService.findById(id);
        if (!structIsEmpty(todo)) {
            data.editingId = id;
            data.editTitle = todo.title;
            data.editDone = todo.done;
        }
    }

    /**
     * Cancel editing
     */
    void function cancelEdit() {
        data.editingId = "";
        data.editTitle = "";
        data.editDone = false;
    }

    /**
     * Save the edited todo item
     */
    void function saveEdit() {
        if (len(trim(data.editTitle)) && len(data.editingId)) {
            TodoService.update(data.editingId, data.editTitle, data.editDone);
            cancelEdit();
            list();
        }
    }

    /**
     * Toggle the done status of a todo item
     */
    void function toggleDone(required string id) {
        TodoService.toggleDone(id);
        list();
    }

}
