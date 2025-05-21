// ./wires/Counter.cfc
component extends="cbwire.models.Component" {
    
    property name="TodoService" inject;
    
    data = {
        "title": ""
    };
    
    // Action
    array function list() {
        return TodoService.list();
    }

    void function add( ) {
        TodoService.add( data.title );
        reset();
    }

    void function delete( required id ) {
        TodoService.delete( id );
    }

}
