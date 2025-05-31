component extends="cbwire.models.Component" {

	property name="TodoService" inject;

	data = {
		"active": true,
		"page"  : 1,
		"limit" : 5,
		"search": "",
		"sortField": "title",
		"sortDirection": "asc",
		"totalCount": 0,
		"totalPages": 0,
		"currentCount": 0,
		"currentItems": [],
	};

	listeners = {
        "refresh-reload": "$refresh",
        "item-saved": "itemSaved",
        "item-edit": "setInactive",
        "refresh-showadd": "setInactive",
		"refresh-showlist": "setActive"
    };

	function itemSaved( required string title ) {
		data.active = true;
		list();
	}

	function setActive() {
		list();
		data.active = true;
	}

	function setInactive() {
		data.active = false;
	}
	
	/**
     * fires when first mounted before any data is rendered
     * @param params - any initial data for the component
     */
    function onMount(  event, rc, prc, params ) {
        list();
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
        data.page = 1;
        list();
    }

	void function delete( required id ) {
        TodoService.delete( id );
		js("showSuccessToast('Deleted todo')");
		var maxPage = ceiling( ( data.totalCount - 1 ) / data.limit );
		if ( data.page > maxPage ) {
			// If we delete the last item on the current page, go to the previous page
			data.page = maxPage;
		}
		list();
	}

	void function startEdit( required id ) {
		dispatch( "item-edit", { id: id } );
	}

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
}
