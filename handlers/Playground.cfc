component extends="coldbox.system.EventHandler" {

	/**
	 * Default Action
	 */
	function index( event, rc, prc ){
		event.setView( "playground/index" );
	}

}
