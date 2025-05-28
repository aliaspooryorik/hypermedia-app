<cfoutput>
<div id="playground-refresh" class="border border-primary border-1 rounded p-3 mb-3">
	mode: #data.mode#
	<div class="d-flex justify-content-between align-items-center">
		<h2>Refresh Wire</h2>
		<button type="button" class="btn btn-primary me-2" wire:click="reloadList">Refresh List</button>
		<button type="button" class="btn btn-primary" wire:click="showAdd">Show Add</button>
		<button type="button" class="btn btn-primary" wire:click="showList">Show List</button>
		<p>Refreshed: #getTickCount()#</p>
	</div>
</div>
</cfoutput>