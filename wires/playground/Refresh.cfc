component extends="cbwire.models.Component" {

	data = {
		mode = "x"
	};
 
    function reload() {
        $refresh();
    }

    function reloadList() {
        dispatch( "refresh-reload" );
    }

    function showAdd() {
        dispatch( "refresh-showadd" );
    }

	function showList() {
		dispatch( "refresh-showlist" );
	}
	
}
