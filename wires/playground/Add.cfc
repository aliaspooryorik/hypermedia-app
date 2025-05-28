component extends="cbwire.models.Component" {

	property name="TodoService" inject;
	
	data = {
		"active": true,
		"title": "",
	};

	listeners = {
        "refresh-showadd": "setActive",
		"refresh-showlist": "setInactive"
    };

	void function setActive() {
		data.active = true;
	}

	void function setInactive() {
		data.active = false;
	}

	// actions...
	void function add( ) {
        TodoService.add( data.title );
        reset();
		dispatch( "refresh-showlist" );
        // cancelEdit(); // Clear any active editing state
        // data.page = 1; // Reset to first page after adding
        // data.toastMessage = "Todo item added successfully!";
        // list();
    }

}