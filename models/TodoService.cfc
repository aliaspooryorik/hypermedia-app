component singleton {

    function init() {
        variables.todos = [];
        return this;
    }

    function onDiComplete() {
        add( 'Task: Create TODO Service', true );
        add( 'Epic: demo app using HTMX', false );
        add( 'Epic: demo app using cbwire', true );
        add( 'Feature: paging controls', true );
        add( 'Feature: items per page', true );
        add( 'Feature: search', true );
        add( 'Feature: sorting', true );
        add( 'Feature: validation', false );
        add( 'Feature: handle empty list', true );
        add( 'Feature: add item', true );
        add( 'Feature: delete item', true );
        add( 'Feature: show toast notification', false );
    }

    void function add( required string title, boolean done = false ) {
        variables.todos.append( {
            "id"     : createUUID(),
            "title"  : title,
            "done"   : done
        } );
    }

    struct function list( 
        required string search, 
        required numeric limit,
        required numeric page,
        required string sortField,
        required string sortDirection ) {

        var dataset = fetch( search, sortField, sortDirection );
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
        
        // Handle zero limit case
        if ( limit == 0 || itemsToReturn <= 0 ) {
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
    
    /**
     * This would normally deletegate to a database or external service.
     * */
    private array function fetch( 
        required string search,
        required string sortProperty,
        required string sortDirection ) {
        var result = [];
        
        // Filter by search if provided
        if ( search.len() ) {
            result = variables.todos.filter( function( el ) {
                return el.title.findNoCase( search ) > 0;
            } );
        } else {
            result = variables.todos;
        }

        // Sort the results
        if ( sortProperty.len() ) {
            result.sort( function( a, b ) {
                var valueA = a[ sortProperty ];
                var valueB = b[ sortProperty ];
                if ( sortDirection == "desc" ) {
                    return compareNoCase( valueB, valueA );
                } else {
                    return compareNoCase( valueA, valueB );
                }
            } );
        }
        
        return result;
    }

    struct function findById( required string id ) {
        for ( var todo in variables.todos ) {
            if ( todo.id == id ) {
                return todo;
            }
        }
        return {};
    }

    boolean function update( required string id, required string title, boolean done = false ) {
        for ( var i = 1; i <= arrayLen( variables.todos ); i++ ) {
            if ( variables.todos[i].id == id ) {
                variables.todos[i].title = title;
                variables.todos[i].done = done;
                return true;
            }
        }
        return false;
    }

    boolean function toggleDone( required string id ) {
        for ( var i = 1; i <= arrayLen( variables.todos ); i++ ) {
            if ( variables.todos[i].id == id ) {
                variables.todos[i].done = !variables.todos[i].done;
                return true;
            }
        }
        return false;
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

    array function getTodos() {
        return variables.todos;
    }

}
