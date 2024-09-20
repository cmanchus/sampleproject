<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" encoding="UTF-8"/>
	
	<xsl:variable name="tableClasses">rsTable</xsl:variable> <!-- classes for HTML element <table> -->
	<xsl:variable name="theadClasses"></xsl:variable> <!-- classes for HTML element <thead> -->
	<xsl:variable name="headRowClasses"></xsl:variable> <!-- classes for HTML element <tr> inside element <thead> -->
	<xsl:variable name="thClasses"></xsl:variable> <!-- classes for HTML element <th> -->
	<xsl:variable name="tbodyClasses"></xsl:variable> <!-- classes for HTML element <tbody> -->
	<xsl:variable name="commonRowClasses"></xsl:variable> <!-- classes for HTML element <tr> inside element <tbody> -->
	<xsl:variable name="tdClasses"></xsl:variable> <!-- classes for HTML element <td> -->

	<xsl:template match="Graph">
		<h1>
			<xsl:value-of select="@name"/>
		</h1>
		<xsl:if test="@description">
			<p>
				<xsl:value-of select="@description"/>
			</p>
		</xsl:if>
		<table class="{$tableClasses}" >
			<thead class="{$theadClasses}">
				<tr class="{$headRowClasses}">
					<th class="{$thClasses}">Created</th>
					<th class="{$thClasses}">Last modified</th>
					<th class="{$thClasses}">Revision</th>
					<th class="{$thClasses}">Gui version</th>
					<th class="{$thClasses}">Number of nodes</th>
				</tr>
			</thead>
			<tbody class="{$tdClasses}">
				<tr class="{$commonRowClasses}">
					<td class="{$tdClasses}">
						<xsl:if test="not(@created)">&#160;</xsl:if>
						<xsl:value-of select="@created"/>
					</td>
					<td class="{$tdClasses}">
						<xsl:if test="not(@modified)">&#160;</xsl:if>
						<xsl:value-of select="@modified"/>
					</td>
					<td class="{$tdClasses}">
						<xsl:if test="not(@revision)">&#160;</xsl:if>
						<xsl:value-of select="@revision"/>
					</td>
					<td class="{$tdClasses}">
						<xsl:if test="not(@guiVersion)">&#160;</xsl:if>
						<xsl:value-of select="@guiVersion"/>
					</td>
					<td class="{$tdClasses}">
						<xsl:value-of select="count(//Node)"/>
					</td>
				</tr>
			</tbody>
		</table>
		
		<xsl:if test="//GraphParameters/GraphParameter or //GraphParameters/GraphParameterFile">
			<div><a href="#Parameters">Parameters</a></div>
		</xsl:if>
		<xsl:if test="//Dictionary/Entry">
			<div><a href="#Dictionary">Dictionary</a></div>
		</xsl:if>
		<xsl:if test="//Sequence">
			<div><a href="#Sequences">Sequences</a></div>
		</xsl:if>
		<xsl:if test="//Connection">
			<div><a href="#Connections">Connections</a></div>
		</xsl:if>
		<xsl:if test="//Metadata or //MetadataGroup/Metadata">
			<div><a href="#Metadata">Metadata</a></div>
		</xsl:if>
		<xsl:if test="//LookupTable">
			<div><a href="#LookupTables">Lookup tables</a></div>
		</xsl:if>
		<xsl:if test="//Note">
			<div><a href="#Notes">Notes</a></div>
		</xsl:if>
		<xsl:if test="//RichTextNote">
			<li><a href="#Notes">Rich Text Notes</a></li>
		</xsl:if>

		<xsl:for-each select="Phase">
			<div><a href="#Phase{@number}">Phase <xsl:value-of select="@number"/></a></div>
		</xsl:for-each>

		<xsl:apply-templates select="Global"/>
		<xsl:apply-templates select="Phase"/>
	</xsl:template>
	
	<!-- Global -->
	<xsl:template match="Global">
		<!-- Parameters -->
		<xsl:if test="GraphParameters/GraphParameterFile or GraphParameters/GraphParameter">
			<a name="Parameters"><h2>Parameters</h2></a>
			<xsl:if test="GraphParameters/GraphParameterFile">
				<h3>External parameter files</h3>
				<table class="{$tableClasses}" border="1">
					<thead class="{$theadClasses}">
						<tr class="{$headRowClasses}">
							<th class="{$thClasses}">External file URL</th>
						</tr>
					</thead>
					<tbody class="{$tdClasses}">
						<xsl:apply-templates select="GraphParameters/GraphParameterFile"/>
					</tbody>
				</table>
			</xsl:if>
			<xsl:if test="GraphParameters/GraphParameter">
				<h3>Internal parameters</h3>
				<table class="{$tableClasses}" border="1">
					<thead class="{$theadClasses}">
						<tr class="{$headRowClasses}">
							<th class="{$thClasses}">Name</th>
							<th class="{$thClasses}">Value</th>
							<th class="{$thClasses}">Secure</th>
							<th class="{$thClasses}">Description</th>
							<th class="{$thClasses}">Public</th>
							<th class="{$thClasses}">Required</th>
							<th class="{$thClasses}">Label</th>
							<th class="{$thClasses}">Value hint</th>
							<th class="{$thClasses}">Category</th>
							<th class="{$thClasses}">Editor type</th>
						</tr>
					</thead>
					<tbody class="{$tdClasses}">
						<xsl:apply-templates select="GraphParameters/GraphParameter"/>
					</tbody>
				</table>
			</xsl:if>
		</xsl:if>
		
		<!-- Dictionary -->
		<xsl:if test="Dictionary/Entry">
			<a name="Dictionary"><h2>Dictionary</h2></a>
			<table class="{$tableClasses}" border="1">
				<thead class="{$theadClasses}">
					<tr class="{$headRowClasses}">
						<th class="{$thClasses}">Id</th>
						<th class="{$thClasses}">Name</th>
						<th class="{$thClasses}">Input</th>
						<th class="{$thClasses}">Output</th>
						<th class="{$thClasses}">Type</th>
						<th class="{$thClasses}">Content Type</th>
						<th class="{$thClasses}">Initial Value</th>
					</tr>
				</thead>
				<tbody class="{$tdClasses}">
					<xsl:apply-templates select="Dictionary/Entry"/>
				</tbody>
			</table>
		</xsl:if>
		
		<!-- Sequences -->
		<xsl:if test="Sequence">
			<a name="Sequences"><h2>Sequences</h2></a>
			<table class="{$tableClasses}" border="1">
				<thead class="{$theadClasses}">
					<tr class="{$headRowClasses}">
						<th class="{$thClasses}">Id</th>
						<th class="{$thClasses}">Name</th>
						<th class="{$thClasses}">Type</th>
						<th class="{$thClasses}">Start</th>
						<th class="{$thClasses}">Step</th>
						<th class="{$thClasses}">Cached</th>
						<th class="{$thClasses}">File URL</th>
					</tr>
				</thead>
				<tbody class="{$tdClasses}">
					<xsl:apply-templates select="Sequence"/>
				</tbody>
			</table>
		</xsl:if>
		
		<!-- Connections -->
		<xsl:if test="Connection">
			<a name="Connections"><h2>Connections</h2></a>
			<xsl:if test="Connection[@dbConfig]">
				<h3>External connections</h3>
				<table class="{$tableClasses}" border="1">
					<thead class="{$theadClasses}">
						<tr class="{$headRowClasses}">
							<th class="{$thClasses}">Id</th>
							<th class="{$thClasses}">Type</th>
							<th class="{$thClasses}">DbConfig</th>
						</tr>
					</thead>
					<tbody class="{$tdClasses}">
						<xsl:apply-templates select="Connection[@dbConfig]"/>
					</tbody>
				</table>
			</xsl:if>
			<xsl:if test="Connection[not(@dbConfig)]">
				<h3>Internal connections</h3>
				<table class="{$tableClasses}" border="1">
					<thead class="{$theadClasses}">
						<tr class="{$headRowClasses}">
							<th class="{$thClasses}">Id</th>
							<th class="{$thClasses}">Type</th>
							<th class="{$thClasses}">DbURL</th>
							<th class="{$thClasses}">User</th>
							<th class="{$thClasses}">Password</th>
							<th class="{$thClasses}">Password encrypted</th>
							<th class="{$thClasses}">Thread safe connection</th>
							<th class="{$thClasses}">Transaction isolation</th>
							<th class="{$thClasses}">DbDriver</th>
							<th class="{$thClasses}">Driver library</th>
						</tr>
					</thead>
					<tbody class="{$tdClasses}">
						<xsl:apply-templates select="Connection[not(@dbConfig)]"/>
					</tbody>
				</table>
			</xsl:if>
		</xsl:if>
		
		<!-- Metadata -->
		<xsl:if test="Metadata or MetadataGroup/Metadata">
			<a name="Metadata"><h2>Metadata</h2></a>
			<xsl:if test="Metadata[@fileURL]">
				<h3>External metadata</h3>
				<table class="{$tableClasses}" border="1">
					<thead class="{$theadClasses}">
						<tr class="{$headRowClasses}">
							<th class="{$thClasses}">Id</th>
							<th class="{$thClasses}">File URL</th>
						</tr>
					</thead>
					<tbody class="{$tdClasses}">
						<xsl:apply-templates select="Metadata[@fileURL]"/>
					</tbody>
				</table>
			</xsl:if>
			
			<xsl:if test="Metadata[not(@fileURL)]">
				<h3>Internal metadata</h3>
				<xsl:apply-templates select="Metadata[not(@fileURL)]" />
			</xsl:if>
			
			<xsl:if test="MetadataGroup/Metadata">
				<h3>Implicit metadata</h3>
				<xsl:apply-templates select="MetadataGroup/Metadata/Record"/>
			</xsl:if>
		</xsl:if>
		
		<!-- LookupTables -->
		<xsl:if test="LookupTable">
			<a name="LookupTables"><h2>Lookup tables</h2></a>
			<xsl:if test="LookupTable[@type='simpleLookup']">
				<h3>Simple lookup tables</h3>
				<table class="{$tableClasses}" border="1">
					<thead class="{$theadClasses}">
						<tr class="{$headRowClasses}">
							<th class="{$thClasses}">Id</th>
							<th class="{$thClasses}">Metadata</th>
							<th class="{$thClasses}">Initial size</th>
							<th class="{$thClasses}">Key</th>
							<th class="{$thClasses}">File URL</th>
							<th class="{$thClasses}">Charset</th>
							<th class="{$thClasses}">Byte mode</th>
							<th class="{$thClasses}">Data</th>
						</tr>
					</thead>
					<tbody class="{$tdClasses}">
						<xsl:apply-templates select="LookupTable[@type='simpleLookup']"/>
					</tbody>
				</table>
			</xsl:if>
			
			<xsl:if test="LookupTable[@type='dbLookup']">
				<h3>DbLookup tables</h3>
				<table class="{$tableClasses}" border="1">
					<thead class="{$theadClasses}">
						<tr class="{$headRowClasses}">
							<th class="{$thClasses}">Id</th>
							<th class="{$thClasses}">Metadata</th>
							<th class="{$thClasses}">Db connection</th>
							<th class="{$thClasses}">Max cached size</th>
							<th class="{$thClasses}">Store null</th>
							<th class="{$thClasses}">SQL query</th>
						</tr>
					</thead>
					<tbody class="{$tdClasses}">
						<xsl:apply-templates select="LookupTable[@type='dbLookup']"/>
					</tbody>
				</table>
			</xsl:if>
			
			<xsl:if test="LookupTable[@type='rangeLookup']">
				<h3>Range lookup tables</h3>
				<table class="{$tableClasses}" border="1">
					<thead class="{$theadClasses}">
						<tr class="{$headRowClasses}">
							<th class="{$thClasses}">Id</th>
							<th class="{$thClasses}">Metadata</th>
							<th class="{$thClasses}">File URL</th>
							<th class="{$thClasses}">Charset</th>
							<th class="{$thClasses}">Locale</th>
							<th class="{$thClasses}">Use I18N</th>
							<th class="{$thClasses}">Byte Mode</th>
							<th class="{$thClasses}">Start fields</th>
							<th class="{$thClasses}">End fields</th>
							<th class="{$thClasses}">Start include</th>
							<th class="{$thClasses}">End include</th>
							<th class="{$thClasses}">Data</th>
						</tr>
					</thead>
					<tbody class="{$tdClasses}">
						<xsl:apply-templates select="LookupTable[@type='rangeLookup']"/>
					</tbody>
				</table>
			</xsl:if>
		</xsl:if>
		
		<!-- Notes -->
		<xsl:if test="Note">
			<a name="Notes"><h2>Notes</h2></a>
			<table class="{$tableClasses}" border="1">
				<thead class="{$theadClasses}">
					<tr class="{$headRowClasses}">
						<th class="{$thClasses}">Id</th>
						<th class="{$thClasses}">Title</th>
						<th class="{$thClasses}">Text</th>
					</tr>
				</thead>
				<tbody class="{$tbodyClasses}">
					<xsl:apply-templates select="Note"/>
				</tbody>
			</table>
		</xsl:if>
		
		<!-- Markup Notes -->
		<xsl:if test="RichTextNote">
			<h2><a name="Notes">Rich Text Notes</a></h2>
			<table class="{$tableClasses}" border="1">
				<thead class="{$theadClasses}">
					<tr class="{$headRowClasses}">
						<th class="{$thClasses}">Id</th>
						<th class="{$thClasses}">Text</th>
					</tr>
				</thead>
				<tbody class="{$tbodyClasses}">
					<xsl:apply-templates select="RichTextNote"/>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	
	<!-- Phases -->
	<xsl:template match="Phase">
		<a name="Phase{@number}"><h2>Phase <xsl:value-of select="@number"/>
		</h2></a>
		
		<!-- Nodes -->
		<xsl:if test="./Node">
			<h3>Nodes</h3>
			<xsl:apply-templates select="./Node"/>
		</xsl:if>
	
		<!-- Edges -->
		<xsl:if test="./Edge">
			<h3>Edges</h3>
			<table class="{$tableClasses}" border="1">
				<thead class="{$theadClasses}">
					<tr class="{$headRowClasses}">
						<th class="{$thClasses}">Id</th>
						<th class="{$thClasses}">Metadata</th>
						<th class="{$thClasses}">From node</th>
						<th class="{$thClasses}">To node</th>
						<th class="{$thClasses}">Input port</th>
						<th class="{$thClasses}">Output port</th>
						<th class="{$thClasses}">Edge type</th>
						<th class="{$thClasses}">Debug mode</th>
						<th class="{$thClasses}">Debug max records</th>
						<th class="{$thClasses}">Debug filter expression</th>
						<th class="{$thClasses}">Debug sample data</th>
						<th class="{$thClasses}">Fast propagate</th>
					</tr>
				</thead>
				<tbody class="{$tdClasses}">
					<xsl:apply-templates select="./Edge"/>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="GraphParameterFile">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@fileURL"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="GraphParameter">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@name"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@value"/>
				<xsl:value-of select="attr[@name='dynamicValue']"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@secure"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="attr[@name='description']"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@public"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@required"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@label"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@defaultHint"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@category"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:choose>
					<xsl:when test="SingleType">
						<xsl:value-of select="SingleType/@name"/>
					</xsl:when>
					<xsl:when test="ComponentReference">
						<xsl:value-of select="ComponentReference/@referencedComponent"/> [<xsl:value-of select="ComponentReference/@referencedProperty"/>]
					</xsl:when>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Sequence">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@id"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@name"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@type"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@start)">&#160;</xsl:if>
				<xsl:value-of select="@start"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@step)">&#160;</xsl:if>
				<xsl:value-of select="@step"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@cached)">&#160;</xsl:if>
				<xsl:value-of select="@cached"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@fileURL)">&#160;</xsl:if>
				<xsl:value-of select="@fileURL"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Connection[@dbConfig]">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@id"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@type"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@dbConfig"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Connection[not(@dbConfig)]">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@id"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@type"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@dbURL"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@user"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@password"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@passwordEncrypted)">&#160;</xsl:if>
				<xsl:value-of select="@passwordEncrypted"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@threadSafeConnection)">&#160;</xsl:if>
				<xsl:value-of select="@threadSafeConnection"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@transactionIsolation)">&#160;</xsl:if>
				<xsl:value-of select="@transactionIsolation"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@dbDriver)">&#160;</xsl:if>
				<xsl:value-of select="@dbDriver"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@driverLibrary)">&#160;</xsl:if>
				<xsl:value-of select="@driverLibrary"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Metadata[@fileURL]">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<a name="{@id}">
					<xsl:value-of select="@id"/>
				</a>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@fileURL"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Metadata/Record">
		<h4>
			<a name="{../@id}">
				<strong><xsl:value-of select="@name"/></strong>
			</a>
		</h4>
		<table class="{$tableClasses}" border="1">
			<thead class="{$theadClasses}">
				<tr class="{$headRowClasses}">
					<th class="{$thClasses}">Type</th>
					<th class="{$thClasses}">Locale</th>
					<th class="{$thClasses}">Record delimiter</th>
					<xsl:choose>
						<xsl:when test="../Sql">
							<th class="{$thClasses}">Field delimiter</th>
							<th class="{$thClasses}">&#160;</th>
						</xsl:when>
						<xsl:otherwise>
							<th class="{$thClasses}">Default delimiter</th>
							<th class="{$thClasses}">Record size</th>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
			</thead>
			<tbody class="{$tdClasses}">
				<tr class="{$commonRowClasses}">
					<td class="{$tdClasses}">
						<xsl:if test="not(@type)">&#160;</xsl:if>
						<xsl:value-of select="@type"/>
					</td>
					<td class="{$tdClasses}">
						<xsl:if test="not(@locale)">&#160;</xsl:if>
						<xsl:value-of select="@locale"/>
					</td>
					<td class="{$tdClasses}">
						<xsl:if test="not(@recordDelimiter)">&#160;</xsl:if>
						<xsl:value-of select="@recordDelimiter"/>
					</td>
					<td class="{$tdClasses}">
						<xsl:if test="not(@fieldDelimiter)">&#160;</xsl:if>
						<xsl:value-of select="@fieldDelimiter"/>
					</td>
					<td class="{$tdClasses}">
						<xsl:if test="not(@recordSize) or ../Sql">&#160;</xsl:if>
						<xsl:value-of select="@recordSize"/>
					</td>
				</tr>
			</tbody>
		</table>
		<xsl:if test="not(../Sql)">
			<h5>Fields</h5>
			<table class="{$tableClasses}" border="1">
				<thead class="{$theadClasses}">
					<tr class="{$headRowClasses}">
						<th class="{$thClasses}">Name</th>
						<th class="{$thClasses}">Type</th>
						<th class="{$thClasses}">Delimiter</th>
						<th class="{$thClasses}">Size</th>
						<th class="{$thClasses}">Format</th>
						<th class="{$thClasses}">Locale</th>
						<th class="{$thClasses}">Nullable</th>
						<th class="{$thClasses}">Default</th>
						<th class="{$thClasses}">Autofilling</th>
						<th class="{$thClasses}">Shift</th>
						<th class="{$thClasses}">Length</th>
						<th class="{$thClasses}">Scale</th>
					</tr>
				</thead>
				<tbody class="{$tdClasses}">
					<xsl:apply-templates/>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Field">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:if test="not(@name)">&#160;</xsl:if>
				<xsl:value-of select="@name"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@type)">&#160;</xsl:if>
				<xsl:value-of select="@type"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@delimiter)">&#160;</xsl:if>
				<xsl:value-of select="@delimiter"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@size)">&#160;</xsl:if>
				<xsl:value-of select="@size"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@format)">&#160;</xsl:if>
				<xsl:value-of select="@format"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@locale)">&#160;</xsl:if>
				<xsl:value-of select="@locale"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@nullable)">&#160;</xsl:if>
				<xsl:value-of select="@nullable"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@default)">&#160;</xsl:if>
				<xsl:value-of select="@default"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@autofilling)">&#160;</xsl:if>
				<xsl:value-of select="@autofilling"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@shift)">&#160;</xsl:if>
				<xsl:value-of select="@shift"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@length)">&#160;</xsl:if>
				<xsl:value-of select="@length"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@scale)">&#160;</xsl:if>
				<xsl:value-of select="@scale"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Metadata[@connection]">
		<h4>
			<a name="{@id}">
				<strong>
					<xsl:choose>
						<xsl:when test="@name">
							<xsl:value-of select="@name" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@id"/>
						</xsl:otherwise>
					</xsl:choose>
				</strong>
			</a>
		</h4>
		<xsl:call-template name="sqlParameters" />
	</xsl:template>
	
	<xsl:template match="Metadata/Sql">
		<xsl:call-template name="sqlParameters" />
	</xsl:template>
	
	<xsl:template name="sqlParameters">
		<h5>SQL query properties</h5>
		<table class="{$tableClasses}" border="1">
			<thead class="{$theadClasses}">
				<tr class="{$headRowClasses}">
					<th class="{$thClasses}">Connection</th>
					<th class="{$thClasses}">SQL query</th>
					<th class="{$thClasses}">SQL optimization</th>
					<th class="{$thClasses}">Unknown JDBC types as String</th>
				</tr>
			</thead>
			<tbody class="{$tdClasses}">
				<td class="{$tdClasses}">
					<xsl:if test="not(@connection)">&#160;</xsl:if>
					<xsl:value-of select="@connection"/>
				</td>
				<td class="{$tdClasses}">
					<xsl:if test="not(@sqlQuery)">&#160;</xsl:if>
					<xsl:value-of select="@sqlQuery"/>
				</td>
				<td class="{$tdClasses}">
					<xsl:if test="not(@sqlOptimization)">&#160;</xsl:if>
					<xsl:value-of select="@sqlOptimization"/>
				</td>
				<td class="{$tdClasses}">
					<xsl:if test="not(@unknownJdbcTypesAsString)">&#160;</xsl:if>
					<xsl:value-of select="@unknownJdbcTypesAsString"/>
				</td>
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template match="LookupTable[@type='dbLookup']">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@id"/>
			</td>
			<td class="{$tdClasses}">
				<a href="#{@metadata}">
					<xsl:value-of select="@metadata"/>
				</a>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@dbConnection)">&#160;</xsl:if>
				<xsl:value-of select="@dbConnection"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@maxCached)">&#160;</xsl:if>
				<xsl:value-of select="@maxCached"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@storeNulls)">&#160;</xsl:if>
				<xsl:value-of select="@storeNulls"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(./attr)">&#160;</xsl:if>
				<xsl:value-of select="./attr"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="LookupTable[@type='simpleLookup']">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@id"/>
			</td>
			<td class="{$tdClasses}">
				<a href="#{@metadata}">
					<xsl:value-of select="@metadata"/>
				</a>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@initialSize)">&#160;</xsl:if>
				<xsl:value-of select="@initialSize"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@key)">&#160;</xsl:if>
				<xsl:value-of select="@key"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@fileURL)">&#160;</xsl:if>
				<xsl:value-of select="@fileURL"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@charset)">&#160;</xsl:if>
				<xsl:value-of select="@charset"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@byteMode)">&#160;</xsl:if>
				<xsl:value-of select="@byteMode"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(./attr)">&#160;</xsl:if>
				<xsl:value-of select="./attr"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="LookupTable[@type='rangeLookup']">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@id"/>
			</td>
			<td class="{$tdClasses}">
				<a href="#{@metadata}">
					<xsl:value-of select="@metadata"/>
				</a>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@fileURL)">&#160;</xsl:if>
				<xsl:value-of select="@fileURL"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@charset)">&#160;</xsl:if>
				<xsl:value-of select="@charset"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@locale)">&#160;</xsl:if>
				<xsl:value-of select="@locale"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@useI18N)">&#160;</xsl:if>
				<xsl:value-of select="@useI18N"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@byteMode)">&#160;</xsl:if>
				<xsl:value-of select="@byteMode"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@startFields)">&#160;</xsl:if>
				<xsl:value-of select="@startFields"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@endFields)">&#160;</xsl:if>
				<xsl:value-of select="@endFields"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@startInclude)">&#160;</xsl:if>
				<xsl:value-of select="@startInclude"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@endInclude)">&#160;</xsl:if>
				<xsl:value-of select="@endInclude"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(./attr)">&#160;</xsl:if>
				<xsl:value-of select="./attr"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Note">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@id"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:value-of select="@title"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(./attr)">&#160;</xsl:if>
				<xsl:value-of select="./attr"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="RichTextNote">
	    <tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@id"/>
			</td>
			<td class="{$tdClasses}" style="padding: 4px;">
                <xsl:choose>
                    <xsl:when test="not(./attr[@name = 'text'])">&#160;</xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="noteBgColor"><xsl:value-of select="@backgroundColor"/></xsl:variable>
                        <xsl:variable name="noteTextColor"><xsl:value-of select="@textColor"/></xsl:variable>
                        <xsl:variable name="noteFontSizeCss"><xsl:if test="@fontSize"> font-size: <xsl:value-of select="@fontSize"/>px;</xsl:if></xsl:variable> 
                        <div class="rich-note-body" style="margin: 0; background-color: #{$noteBgColor}; color: #{$noteTextColor};{$noteFontSizeCss}">
                            <xsl:copy-of select="attr[@name = 'text']/*" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Edge">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}">
				<xsl:value-of select="@id"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:choose>
          			<xsl:when test="@metadata">
            			<a href="#{@metadata}">
							<xsl:value-of select="@metadata"/>
						</a>
          			</xsl:when>
          			<xsl:when test="@persistedImplicitMetadata">
          				<a href="#{@persistedImplicitMetadata}">
          					<xsl:if test="@metadataRef">
          						<xsl:value-of select="@persistedImplicitMetadata"/> (auto-propagated from <xsl:value-of select="@metadataRef"/>)
          					</xsl:if>
          					<xsl:if test="not(@metadataRef)">
          						<xsl:value-of select="@persistedImplicitMetadata"/> (auto-propagated)
          					</xsl:if>
						</a>
          			</xsl:when>
          			<xsl:when test="@metadataRefState">
          				<!-- edge reference is invalid -->
            			invalid edge reference
          			</xsl:when>
          			<xsl:when test="not(@metadataRefState) and @metadataRef">
          				<!-- reference is valid, but no metadata propagated -->
            			reference to edge with no metadata
          			</xsl:when>
          			<xsl:otherwise>no metadata</xsl:otherwise>
        		</xsl:choose>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@fromNode)">&#160;</xsl:if>
				<a href="#{substring-before(@fromNode,':')}">
					<xsl:value-of select="@fromNode"/>
				</a>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@toNode)">&#160;</xsl:if>
				<a href="#{substring-before(@toNode,':')}">
					<xsl:value-of select="@toNode"/>
				</a>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@inPort)">&#160;</xsl:if>
				<xsl:value-of select="@inPort"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@outPort)">&#160;</xsl:if>
				<xsl:value-of select="@outPort"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@edgeType)">&#160;</xsl:if>
				<xsl:value-of select="@edgeType"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@debugMode)">&#160;</xsl:if>
				<xsl:value-of select="@debugMode"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@debugMaxRecords)">&#160;</xsl:if>
				<xsl:value-of select="@debugMaxRecords"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@debugFilterExpression)">&#160;</xsl:if>
				<xsl:value-of select="@debugFilterExpression"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@debugSampleData)">&#160;</xsl:if>
				<xsl:value-of select="@debugSampleData"/>
			</td>
			<td class="{$tdClasses}">
				<xsl:if test="not(@fastPropagate)">&#160;</xsl:if>
				<xsl:value-of select="@fastPropagate"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Dictionary/Entry">
		<tr class="{$commonRowClasses}">
			<td class="{$tdClasses}"><xsl:value-of select="@id"/></td>
			<td class="{$tdClasses}"><xsl:value-of select="@name"/></td>
			<td class="{$tdClasses}"><xsl:value-of select="@input"/></td>
			<td class="{$tdClasses}"><xsl:value-of select="@output"/></td>
			<td class="{$tdClasses}"><xsl:value-of select="@type"/></td>
			<td class="{$tdClasses}"><xsl:value-of select="@contentType"/></td>
			<td class="{$tdClasses}"><xsl:value-of select="@dictval.value"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Node">
		<a name="{@id}">
			<h4>
				<xsl:if test="@guiName">
					<xsl:value-of select="@guiName"/>
				</xsl:if>
				<xsl:if test="not(@guiName)">
					<xsl:value-of select="@id"/>
				</xsl:if>
			</h4>
		</a>
		<table class="{$tableClasses}" border="1">
			<thead class="{$theadClasses}">
				<tr class="{$headRowClasses}">
					<th class="{$thClasses}">
						<xsl:value-of select="local-name(@id)"/>
					</th>
					<th class="{$thClasses}">
						<xsl:value-of select="local-name(@type)"/>
					</th>
					<xsl:for-each select="@*">
						<xsl:if test="not(local-name()='id') and not(local-name()='type') and not(starts-with(name(), 'gui'))">
							<th class="{$thClasses}">
								<xsl:value-of select="local-name()"/>
							</th>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="attr">
						<th class="{$thClasses}">
							<xsl:value-of select="@name"/>
						</th>
					</xsl:for-each>
				</tr>
			</thead>
			<tbody class="{$tdClasses}">
				<tr class="{$commonRowClasses}">
					<td class="{$tdClasses}">
						<xsl:value-of select="@id"/>
					</td>
					<td class="{$tdClasses}">
						<xsl:value-of select="@type"/>
					</td>
					<xsl:for-each select="@*">
						<xsl:if test="not(local-name()='id') and not(local-name()='type') and not(starts-with(local-name(), 'gui'))">
							<td class="{$tdClasses}">
								<xsl:value-of select="."/>
							</td>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="attr">
						<td class="{$tdClasses}">
							<pre><code><xsl:value-of select="."/></code></pre>
						</td>
					</xsl:for-each>
				</tr>
			</tbody>
		</table>
	</xsl:template>

</xsl:stylesheet>
