<cfoutput>
<div id="playground-add" class="border border-primary border-1 rounded p-3 mb-3" x-show="$wire.active">

	<div class="col-md-6">
		<form wire:submit="save" role="form" aria-label="#getMode()# todo form">
			<label class="form-label" for="todo-title-input">#getMode()# todo:</label>
			<div class="input-group mb-2">
				<input 
					type="text" 
					id="todo-title-input"
					wire:model="title" 
					placeholder="New todo..." 
					class="form-control"
					aria-describedby="todo-title-help"
					required
					maxlength="255"
				>
				<button type="submit" class="btn btn-primary" wire:loading.attr="disabled" wire:target="save">
					<span wire:loading.remove wire:target="save">
						<i class="bi bi-plus-circle" aria-hidden="true"></i> Save
					</span>
					<span wire:loading wire:target="save">
						<i class="bi bi-hourglass" aria-hidden="true"></i> Saving...
					</span>
				</button>
			</div>
			<small id="todo-title-help" class="form-text text-muted">Enter a descriptive title for your todo item</small>
			<div class="form-check">
				<input 
					type="checkbox" 
					wire:model="done" 
					class="form-check-input" 
					id="todo-done-checkbox"
				>
				<label class="form-check-label" for="todo-done-checkbox">
					Mark as completed
				</label>
			</div>
		</form>
	</div>

	<cfif data.debug>
		<cfdump var="#data#" label="Data" />
	</cfif>
	
</div>
</cfoutput>