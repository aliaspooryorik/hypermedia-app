component singleton {

    function init() {
        variables.todos = [];
        add( 'Task: Create TODO Service' );
        add( 'Epic: demo app using HTMX' );
        add( 'Epic: demo app using cbwire' );
        add( 'Feature: paging controls' );
        add( 'Feature: items per page' );
        add( 'Feature: search' );
        add( 'Feature: sorting' );
        add( 'Feature: validation' );
        add( 'Feature: handle empty list' );
        add( 'Feature: add item' );
        add( 'Feature: delete item' );
        add( 'Feature: show toast notification' );
        return this;
    }

    void function add( required string title ) {
        variables.todos.append( {
            id     : createUUID(),
            title  : title,
            active : true
        } );
    }

    struct function list( 
        required string search, 
        required numeric limit,
        required numeric page ) {

        var dataset = fetch( search );
        var offset = ( page - 1 ) * limit;
        var startIndex = offset + 1;
        var datasetLength = arrayLen( dataset );
        
        // Calculate how many items to return (length parameter for slice)
        var itemsToReturn = min( limit, datasetLength - offset );
        
        // If startIndex exceeds dataset length, return empty array
        if ( startIndex > datasetLength ) {
            return {
                totalCount: datasetLength,
                page: page,
                limit: limit,
                data: [],
            };
        }
        
        return {
            totalCount: datasetLength,
            page: page,
            limit: limit,
            data: dataset.slice( startIndex, itemsToReturn ),
        };
    }
    
    
    private array function fetch( 
        required string search ) {
        var result = [];
        if ( search.len() ) {
            return variables.todos.filter( function( el ) {
                return el.title.findNoCase( search ) > 0;
            } );
        }
        return variables.todos;
    }

    boolean function delete( required string id ) {
        sleep( 500 ); // Simulate a delay for the delete operation
        for ( var i = 1; i <= arrayLen( variables.todos ); i++ ) {
            if ( variables.todos[i].id == id ) {
                arrayDeleteAt( variables.todos, i );
                return true;
            }
        }
        return false;
    }

}
