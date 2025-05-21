component singleton {

    function init() {
        variables.todos = [];
        add( 'Example TODO' );
        return this;
    }

    void function add( required string title ) {
        variables.todos.append( {
            id     : createUUID(),
            title  : title,
            active : true
        } );
    }

    array function list( ) {
        return variables.todos;
    }

    boolean function delete( required string id ) {
        for ( var i = 1; i <= arrayLen( variables.todos ); i++ ) {
            if ( variables.todos[i].id == id ) {
                arrayDeleteAt( variables.todos, i );
                return true;
            }
        }
        return false;
    }

}
