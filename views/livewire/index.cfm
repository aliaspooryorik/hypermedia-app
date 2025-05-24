<cfoutput>

<h2>cbwire</h2>
<p>Page loaded at #timeFormat( now(), "short" )#</p>

#wire( name="todo", lazy=true )#

</cfoutput>