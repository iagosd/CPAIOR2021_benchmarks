# CP 2021 submission number ?

## Open access benchmarks

In order to replicate our experiments you need to manually update the shaft values.
<b>For OMT files:</b>
<ul>
	<li>The <i>shaft_w</i> and <i>shaft_d</i> assertion values are at the end of the file, just before minimization</li>
</ul>

<b>For MiniZinc files</b>
<ul>
	<li>The <i>shaft_w</i> and <i>shaft_d</i> assignment is at the beginning, after the definition of the index selection variables</li>
</ul>