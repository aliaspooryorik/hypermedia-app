<cfoutput>
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">Todo List</h5>
        <span class="badge bg-secondary">#prc.totalCount# total items</span>
    </div>
    <div class="card-body">
        <cfif arrayLen(prc.todos) EQ 0>
            <div class="alert alert-info" role="alert">
                <h6 class="alert-heading">No todos found</h6>
                <cfif len(prc.search)>
                    <p class="mb-0">Try adjusting your search criteria.</p>
                <cfelse>
                    <p class="mb-0">Add your first todo item above!</p>
                </cfif>
            </div>
        <cfelse>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th scope="col" style="width: 50%;">
                                <button type="button" 
                                        class="btn btn-link p-0 text-decoration-none text-dark fw-bold d-flex align-items-center"
                                        style="border: none; background: none;"
                                        hx-get="#event.buildLink('htmx.list')#"
                                        hx-vals='{"sortField": "title", "sortDirection": "#prc.sortField EQ 'title' AND prc.sortDirection EQ 'asc' ? 'desc' : 'asc'#"}'
                                        hx-target="##todo-container"
                                        hx-include="[name='search'], [name='limit'], [name='page']">
                                    Title
                                    <cfif prc.sortField EQ 'title'>
                                        <cfif prc.sortDirection EQ 'desc'>
                                            <i class="bi bi-caret-down-fill ms-1" aria-hidden="true"></i>
                                        <cfelse>
                                            <i class="bi bi-caret-up-fill ms-1" aria-hidden="true"></i>
                                        </cfif>
                                    <cfelse>
                                        <i class="bi bi-caret-up ms-1 text-muted" aria-hidden="true"></i>
                                    </cfif>
                                </button>
                            </th>
                            <th scope="col" style="width: 15%;">
                                <button type="button" 
                                        class="btn btn-link p-0 text-decoration-none text-dark fw-bold d-flex align-items-center"
                                        style="border: none; background: none;"
                                        hx-get="#event.buildLink('htmx.list')#"
                                        hx-vals='{"sortField": "done", "sortDirection": "#prc.sortField EQ 'done' AND prc.sortDirection EQ 'asc' ? 'desc' : 'asc'#"}'
                                        hx-target="##todo-container"
                                        hx-include="[name='search'], [name='limit'], [name='page']">
                                    Status
                                    <cfif prc.sortField EQ 'done'>
                                        <cfif prc.sortDirection EQ 'desc'>
                                            <i class="bi bi-caret-down-fill ms-1" aria-hidden="true"></i>
                                        <cfelse>
                                            <i class="bi bi-caret-up-fill ms-1" aria-hidden="true"></i>
                                        </cfif>
                                    <cfelse>
                                        <i class="bi bi-caret-up ms-1 text-muted" aria-hidden="true"></i>
                                    </cfif>
                                </button>
                            </th>
                            <th scope="col" style="width: 35%;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop array="#prc.todos#" item="todo">
                            <tr id="todo-row-#todo.id#">
                                <td>
                                    <span id="todo-title-#todo.id#">#encodeForHTML(todo.title)#</span>
                                </td>
                                <td>
                                    <cfif todo.done>
                                        <span class="badge bg-success">Completed</span>
                                    <cfelse>
                                        <span class="badge bg-warning text-dark">Pending</span>
                                    </cfif>
                                </td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <!-- Toggle Status Button -->
                                        <button type="button" 
                                                class="btn btn-sm <cfif todo.done>btn-outline-warning<cfelse>btn-outline-success</cfif>"
                                                hx-post="#event.buildLink('htmx.toggle')#"
                                                hx-vals='{"id": "#todo.id#"}'
                                                hx-target="##todo-container"
                                                hx-include="[name='search'], [name='limit'], [name='sortField'], [name='sortDirection'], [name='page']"
                                                title="<cfif todo.done>Mark as Pending<cfelse>Mark as Complete</cfif>">
                                            <cfif todo.done>
                                                <i class="bi bi-arrow-counterclockwise"></i> Pending
                                            <cfelse>
                                                <i class="bi bi-check-circle"></i> Complete
                                            </cfif>
                                        </button>
                                        
                                        <!-- Edit Button -->
                                        <button type="button" 
                                                class="btn btn-sm btn-outline-primary"
                                                hx-get="#event.buildLink('htmx.editForm')#"
                                                hx-vals='{"id": "#todo.id#"}'
                                                hx-target="##todo-row-#todo.id#"
                                                hx-swap="outerHTML"
                                                title="Edit Todo">
                                            <i class="bi bi-pencil"></i> Edit
                                        </button>
                                        
                                        <!-- Delete Button -->
                                        <button type="button" 
                                                class="btn btn-sm btn-outline-danger"
                                                hx-post="#event.buildLink('htmx.delete')#"
                                                hx-vals='{"id": "#todo.id#"}'
                                                hx-target="##todo-container"
                                                hx-include="[name='search'], [name='limit'], [name='sortField'], [name='sortDirection'], [name='page']"
                                                hx-confirm="Are you sure you want to delete this todo?"
                                                title="Delete Todo">
                                            <i class="bi bi-trash"></i> Delete
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <cfif prc.totalPages GT 1>
                <nav aria-label="Todo pagination" class="mt-3">
                    <ul class="pagination justify-content-center">
                        <!-- Previous Button -->
                        <li class="page-item <cfif prc.currentPage EQ 1>disabled</cfif>">
                            <button class="page-link" 
                                    <cfif prc.currentPage GT 1>
                                    hx-get="#event.buildLink('htmx.list')#"
                                    hx-vals='{"page": "#prc.currentPage - 1#"}'
                                    hx-target="##todo-container"
                                    hx-include="[name='search'], [name='limit'], [name='sortField'], [name='sortDirection']"
                                    </cfif>>
                                <i class="bi bi-chevron-left"></i> Previous
                            </button>
                        </li>

                        <!-- Page Numbers -->
                        <cfset startPage = max(1, prc.currentPage - 2)>
                        <cfset endPage = min(prc.totalPages, prc.currentPage + 2)>
                        
                        <cfif startPage GT 1>
                            <li class="page-item">
                                <button class="page-link" 
                                        hx-get="#event.buildLink('htmx.list')#"
                                        hx-vals='{"page": "1"}'
                                        hx-target="##todo-container"
                                        hx-include="[name='search'], [name='limit'], [name='sortField'], [name='sortDirection']">1</button>
                            </li>
                            <cfif startPage GT 2>
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </cfif>
                        </cfif>

                        <cfloop from="#startPage#" to="#endPage#" index="pageNum">
                            <li class="page-item <cfif pageNum EQ prc.currentPage>active</cfif>">
                                <button class="page-link" 
                                        <cfif pageNum NEQ prc.currentPage>
                                        hx-get="#event.buildLink('htmx.list')#"
                                        hx-vals='{"page": "#pageNum#"}'
                                        hx-target="##todo-container"
                                        hx-include="[name='search'], [name='limit'], [name='sortField'], [name='sortDirection']"
                                        </cfif>>#pageNum#</button>
                            </li>
                        </cfloop>

                        <cfif endPage LT prc.totalPages>
                            <cfif endPage LT prc.totalPages - 1>
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </cfif>
                            <li class="page-item">
                                <button class="page-link" 
                                        hx-get="#event.buildLink('htmx.list')#"
                                        hx-vals='{"page": "#prc.totalPages#"}'
                                        hx-target="##todo-container"
                                        hx-include="[name='search'], [name='limit'], [name='sortField'], [name='sortDirection']">#prc.totalPages#</button>
                            </li>
                        </cfif>

                        <!-- Next Button -->
                        <li class="page-item <cfif prc.currentPage EQ prc.totalPages>disabled</cfif>">
                            <button class="page-link" 
                                    <cfif prc.currentPage LT prc.totalPages>
                                    hx-get="#event.buildLink('htmx.list')#"
                                    hx-vals='{"page": "#prc.currentPage + 1#"}'
                                    hx-target="##todo-container"
                                    hx-include="[name='search'], [name='limit'], [name='sortField'], [name='sortDirection']"
                                    </cfif>>
                                Next <i class="bi bi-chevron-right"></i>
                            </button>
                        </li>
                    </ul>
                </nav>
            </cfif>

            <div class="text-center text-muted mt-3">
                <small>
                    Showing #arrayLen(prc.todos)# of #prc.totalCount# items
                    (Page #prc.currentPage# of #prc.totalPages#)
                </small>
            </div>
        </cfif>
    </div>
</div>
</cfoutput>
