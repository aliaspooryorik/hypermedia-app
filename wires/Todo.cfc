// ./wires/Counter.cfc
component extends="cbwire.models.Component" {
    
    property name="TodoService" inject;

    data = {
        "title": "",
        "search": ""
    };
    
    // Action
    array function list() {
        return TodoService.list().filter( ( el ) => data.search.len() == 0 || el.title.findNoCase( data.search ) > 0 );
    }

    void function add( ) {
        TodoService.add( data.title );
        reset();
    }

    void function delete( required id ) {
        TodoService.delete( id );
    }

}
