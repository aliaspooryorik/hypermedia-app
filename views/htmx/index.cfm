<cfoutput>
<div class="container mt-4">
    <h2>HTMX Todo CRUD App</h2>
    <p class="text-muted">Page loaded at #timeFormat( now(), "short" )#</p>

    <!-- Add Todo Form -->
    <div class="card mb-4">
        <div class="card-header">
            <h5 class="mb-0">Add New Todo</h5>
        </div>
        <div class="card-body">
            <form hx-post="#event.buildLink('htmx.add')#" 
                  hx-target="##todo-container" 
                  hx-swap="innerHTML"
                  class="row g-3">
                <div class="col-md-8">
                    <input type="text" 
                           name="title" 
                           class="form-control" 
                           placeholder="Enter todo item..." 
                           required>
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-plus-circle"></i> Add Todo
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Search and Filter Controls -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-8">
                    <label for="search" class="form-label">Search</label>
                    <input type="text" 
                           id="search"
                           name="search" 
                           class="form-control" 
                           placeholder="Search todos..."
                           value="#encodeForHTMLAttribute(prc.search)#"
                           hx-get="#event.buildLink('htmx.list')#"
                           hx-target="##todo-container"
                           hx-trigger="keyup changed delay:300ms"
                           hx-include="[name='limit'], [name='sortField'], [name='sortDirection']">
                </div>
                <div class="col-md-4">
                    <label for="limit" class="form-label">Items per page</label>
                    <select name="limit" 
                            id="limit"
                            class="form-select"
                            hx-get="#event.buildLink('htmx.list')#"
                            hx-target="##todo-container"
                            hx-include="[name='search'], [name='sortField'], [name='sortDirection']">
                        <option value="5" #prc.limit EQ 5 ? 'selected' : ''#>5</option>
                        <option value="10" #prc.limit EQ 10 ? 'selected' : ''#>10</option>
                        <option value="15" #prc.limit EQ 15 ? 'selected' : ''#>15</option>
                        <option value="20" #prc.limit EQ 20 ? 'selected' : ''#>20</option>
                    </select>
                </div>
            </div>
        </div>
    </div>

    <!-- Todo List Container -->
    <div id="todo-container">
        <cfinclude template="todoList.cfm">
    </div>

    <!-- Hidden inputs for pagination -->
    <input type="hidden" name="page" value="#prc.currentPage#" id="current-page">
</div>

<!-- Include Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

<!-- Include HTMX -->
<script src="https://unpkg.com/htmx.org@1.9.10"></script>

<style>
.table th {
    background-color: ##f8f9fa;
}
.btn-sm {
    padding: 0.25rem 0.5rem;
    font-size: 0.875rem;
}
.badge {
    font-size: 0.75em;
}
.table th button:hover {
    background-color: ##e9ecef !important;
    color: ##495057 !important;
}
.table th button {
    width: 100%;
    text-align: left;
    justify-content: flex-start;
}
.table th button:focus {
    box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
}
</style>
</cfoutput>