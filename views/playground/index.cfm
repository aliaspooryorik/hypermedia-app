<cfoutput>

<p>Page loaded at #timeFormat( now(), "short" )#</p>

<div id="playground-index" class="border border-secondary border-1 rounded p-3 mb-3">
	<h1>Playground Wire:</h1>
    #wire( "playground.Refresh" )#
	#wire( "playground.Add", { "active": false } )#
	#wire( "playground.List", { "active": true } )#
</div>

</cfoutput>