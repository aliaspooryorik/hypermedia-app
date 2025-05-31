<cfoutput>
<div id="playground-add" class="border border-primary border-1 rounded p-3 mb-3" x-show="$wire.active">

	<div class="col-md-6">
		<form wire:submit="save">
			<label class="form-label">#getMode()# todo:</label>
			<div class="input-group mb-2">
				<input 
					type="text" 
					wire:model="title" 
					placeholder="New todo..." 
					class="form-control"
					required
				>
				<button type="submit" class="btn btn-primary">
					<i class="bi bi-plus-circle" aria-hidden="true"></i> Save
				</button>
			</div>
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

	
	<cfdump var="#data#" label="Data" />
	
</div>
</cfoutput>