<cfoutput>
<tr id="todo-row-#prc.todo.id#">
    <td colspan="3">
        <form hx-post="#event.buildLink('htmx.update')#" 
              hx-target="##todo-container"
              hx-include="[name='search'], [name='limit'], [name='sortField'], [name='sortDirection'], [name='page']"
              class="p-3 bg-light rounded">
            <input type="hidden" name="id" value="#prc.todo.id#">
            
            <div class="row g-3 align-items-center">
                <div class="col-md-6">
                    <label for="edit-title-#prc.todo.id#" class="form-label">Title</label>
                    <input type="text" 
                           id="edit-title-#prc.todo.id#"
                           name="title" 
                           class="form-control" 
                           value="#encodeForHTMLAttribute(prc.todo.title)#" 
                           required>
                </div>
                <div class="col-md-3">
                    <label for="edit-done-#prc.todo.id#" class="form-label">Status</label>
                    <select id="edit-done-#prc.todo.id#" name="done" class="form-select">
                        <option value="false" #NOT prc.todo.done ? 'selected' : ''#>Pending</option>
                        <option value="true" #prc.todo.done ? 'selected' : ''#>Completed</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">&nbsp;</label>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-success btn-sm">
                            <i class="bi bi-check"></i> Save
                        </button>
                        <button type="button" 
                                class="btn btn-secondary btn-sm"
                                hx-get="#event.buildLink('htmx.list')#"
                                hx-target="##todo-container"
                                hx-include="[name='search'], [name='limit'], [name='sortField'], [name='sortDirection'], [name='page']">
                            <i class="bi bi-x"></i> Cancel
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </td>
</tr>
</cfoutput>
