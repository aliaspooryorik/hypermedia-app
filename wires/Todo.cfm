<cfoutput>
<section class="m-3">

    <form wire:submit="add" class="my-3">
        <p>Enter a new item and click `Add`:</p>
        <input 
            type="text" 
            wire:model="title" 
            placeholder="New todo item" 
            class="form-control" 
            style="display:inline-block; width:auto; margin-right:8px;"
        >
        <button type="submit" class="btn btn-primary">
            <i class="bi bi-plus-circle" aria-hidden="true"></i> Add Item
        </button>
    </form>
    
    <cfif list().isEmpty()>
        <h2 class="text-blue">No items found</h2>
    <cfelse>
        <ol class="list-group">
            <cfloop array="#list()#" item="item">
                <li wire:key="item-#item.id#" class="list-group-item d-flex justify-content-between align-items-center">
                    #item.title#
                    <button class="btn btn-secondary" wire:click="delete( '#item.id#' )">
                        <i class="bi bi-trash" aria-hidden="true"></i> Remove
                    </button>
                </li>
            </cfloop>
        </ol>
    </cfif>

</section>    
</cfoutput>