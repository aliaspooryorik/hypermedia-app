<cfoutput>
<section class="m-3">

    <form wire:submit="add" class="my-3">
        <p>Enter a new item and click `Add`:</p>
        <input 
            type="text" 
            wire:model="title" 
            placeholder="New todo..." 
            class="form-control" 
            style="display:inline-block; width:auto; margin-right:8px;"
        >
        <button type="submit" class="btn btn-primary">
            <i class="bi bi-plus-circle" aria-hidden="true"></i> Add Item
        </button>
    </form>

    <div class="mb-3">
        <input 
            type="text" 
            wire:model.live="search" 
            placeholder="search..." 
            class="form-control" 
            style="display:inline-block; width:auto; margin-right:8px;"
        >
    </div>
    
    <cfif data.currentItems.isEmpty()>
        <div class="alert alert-info" role="alert">
            <h5 class="alert-heading">No items found</h5>
            <cfif data.search.len()>
                <p class="mb-0">Try adjusting your search criteria.</p>
            <cfelse>
                <p class="mb-0">Add your first todo item above!</p>
            </cfif>
        </div>
    <cfelse>
        <table class="table table-striped mb-3">
            <thead>
                <tr>
                    <th scope="col">
                        <button 
                            type="button" 
                            class="btn btn-link p-0 text-decoration-none text-dark fw-bold d-flex align-items-center"
                            wire:click="toggleSort('title')"
                            style="border: none; background: none;"
                        >
                            Todo Item
                            <cfif data.sortField EQ 'title'>
                                <cfif data.sortDirection EQ 'desc'>
                                    <i class="bi bi-caret-down-fill ms-1" aria-hidden="true"></i>
                                <cfelse>
                                    <i class="bi bi-caret-up-fill ms-1" aria-hidden="true"></i>
                                </cfif>
                            <cfelse>
                                <i class="bi bi-caret-up ms-1 text-muted" aria-hidden="true"></i>
                            </cfif>
                        </button>
                    </th>
                    <th scope="col">
                        <button 
                            type="button" 
                            class="btn btn-link p-0 text-decoration-none text-dark fw-bold d-flex align-items-center"
                            wire:click="toggleSort('done')"
                            style="border: none; background: none;"
                        >
                            Status
                            <cfif data.sortField EQ 'done'>
                                <cfif data.sortDirection EQ 'desc'>
                                    <i class="bi bi-caret-down-fill ms-1" aria-hidden="true"></i>
                                <cfelse>
                                    <i class="bi bi-caret-up-fill ms-1" aria-hidden="true"></i>
                                </cfif>
                            <cfelse>
                                <i class="bi bi-caret-up ms-1 text-muted" aria-hidden="true"></i>
                            </cfif>
                        </button>
                    </th>
                    <th scope="col">Actions</th>
                </tr>
            </thead>
            <tbody>
                <cfloop array="#data.currentItems#" item="item">
                    <tr wire:key="item-#item.id#">
                        <td>#item.title#</td>
                        <td>
                            <cfif item.done>
                                <span class="badge rounded-pill bg-success">Done</span>
                            <cfelse>
                                <span class="badge rounded-pill bg-warning text-dark">Pending</span>
                            </cfif>
                        </td>
                        <td>
                            <button class="btn btn-outline-danger btn-sm" wire:click="delete( '#item.id#' )" wire:loading.attr="disabled" wire:target="delete( '#item.id#' )">
                                <i class="bi bi-trash" aria-hidden="true"></i> Remove
                            </button>
                        </td>
                    </tr>
                </cfloop>
            </tbody>
        </table>

        <small class="text-muted ms-2">
            Showing #data.currentCount# of #data.totalCount# items
             (Page #data.page# of #data.totalPages#)
        </small>

        
        <!--- Pagination Controls --->
        <cfif data.totalPages GT 1>
            <div class="d-flex justify-content-between align-items-center flex-wrap mt-3">
                <!--- Pagination controls on the left --->
                <nav aria-label="Todo pagination">
                    <ul class="pagination mb-0">
                        <!--- Previous Button --->
                        <li class="page-item <cfif NOT hasPreviousPage()>disabled</cfif>">
                            <button 
                                class="page-link" 
                                wire:click="previousPage"
                                <cfif NOT hasPreviousPage()>disabled</cfif>
                                aria-label="Previous"
                            >
                                <span aria-hidden="true">&laquo;</span>
                            </button>
                        </li>

                        <!--- Page Numbers --->
                        <cfset startPage = max(1, data.page - 2)>
                        <cfset endPage = min(data.totalPages, data.page + 2)>
                        
                        <!--- Show first page if we're not starting from 1 --->
                        <cfif startPage GT 1>
                            <li class="page-item">
                                <button class="page-link" wire:click="goToPage(1)">1</button>
                            </li>
                            <cfif startPage GT 2>
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </cfif>
                        </cfif>

                        <!--- Current page range --->
                        <cfloop from="#startPage#" to="#endPage#" index="pageNum">
                            <li class="page-item <cfif pageNum EQ data.page>active</cfif>">
                                <button 
                                    class="page-link" 
                                    wire:click="goToPage(#pageNum#)"
                                    <cfif pageNum EQ data.page>aria-current="page"</cfif>
                                >
                                    #pageNum#
                                </button>
                            </li>
                        </cfloop>

                        <!--- Show last page if we're not ending at the last page --->
                        <cfif endPage LT data.totalPages>
                            <cfif endPage LT data.totalPages - 1>
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </cfif>
                            <li class="page-item">
                                <button class="page-link" wire:click="goToPage(#data.totalPages#)">#data.totalPages#</button>
                            </li>
                        </cfif>

                        <!--- Next Button --->
                        <li class="page-item <cfif NOT hasNextPage()>disabled</cfif>">
                            <button 
                                class="page-link" 
                                wire:click="nextPage"
                                <cfif NOT hasNextPage()>disabled</cfif>
                                aria-label="Next"
                            >
                                <span aria-hidden="true">&raquo;</span>
                            </button>
                        </li>
                    </ul>
                </nav>

                <!--- Right side controls --->
                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <!--- Direct page input --->
                    <div class="d-flex align-items-center">
                        <span class="small text-muted me-2">Go to page:</span>
                        <input 
                            type="number" 
                            min="1" 
                            max="#data.totalPages#"
                            placeholder="#data.page#"
                            class="form-control form-control-sm" 
                            style="width: 70px;"
                            wire:input="goToPage($event.target.value)"
                            wire:keydown.enter="goToPage($event.target.value)"
                        >
                    </div>
                    
                    <!--- Items per page selector --->
                    <span class="align-self-center me-2 small text-muted">Items per page:</span>
                    <div class="btn-group" role="group" aria-label="Items per page">
                        <cfloop list="5,10,15,20" index="size">
                            <button 
                                type="button" 
                                class="btn btn-outline-secondary btn-sm <cfif data.limit EQ size>active</cfif>"
                                wire:click="setItemsPerPage(#size#)"
                            >
                                #size#
                            </button>
                        </cfloop>
                    </div>
                </div>
            </div>
        </cfif>

    </cfif>

    

    
    <p class="text-muted mt-2">
        <!--- This timestamp will never update --->
        <span wire:ignore>Component first loaded #now()#.</span>
        <span>Component last updated #now()#.</span>
    </p>
</section>    
</cfoutput>