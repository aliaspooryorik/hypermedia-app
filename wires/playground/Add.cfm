<cfoutput>
<div id="playground-add" class="border border-primary border-1 rounded p-3 mb-3" x-show="$wire.active">

	<div class="col-md-6">
		<form wire:submit="add">
			<label class="form-label">Add new todo:</label>
			<div class="input-group">
				<input 
					type="text" 
					wire:model="title" 
					placeholder="New todo..." 
					class="form-control"
					required
				>
				<button type="submit" class="btn btn-primary">
					<i class="bi bi-plus-circle" aria-hidden="true"></i> Add
				</button>
			</div>
		</form>
	</div>
	
</div>
</cfoutput>