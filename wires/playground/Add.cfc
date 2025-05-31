component extends="cbwire.models.Component" {

	property name="TodoService" inject;
	
	data = {
		"active": true,
		"debug": true,
		"id": "",
		"title": "",
		"done": false
	};

	listeners = {
		"item-edit": "doEdit",
		"refresh-showadd": "setActive",
		"refresh-showlist": "setInactive"
	};

	void function setActive() {
		reset();
	}

	void function setInactive() {
		data.active = false;
	}

	// actions...
	void function save( ) {
		if (data.id == "") {
			TodoService.add( data.title, data.done );
		}
		else {
			// edit existing item
			TodoService.update( data.id, data.title, data.done );
		}
		dispatch( "item-saved", { "title": data.title } );
		reset();
		// hide the form
		setInactive();
	}

	// view helpers...
	string function getMode() {
		if (data.id == "") {
			return "add";
		}
		return "edit";
	}

	// private methods...
	void function doEdit( required string id ) {
		var item = TodoService.findById( id );
		data.append( item, true );
		data.active = true;
	}

}