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

	<xsl:param name="sandboxPath"/>
	
	
<!-- 	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="Record/@name"/>
				</title>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
 -->	
	<xsl:template match="Record">
		<h1>
			<xsl:value-of select="@name"/>
		</h1>
		<h2><xsl:value-of select="$sandboxPath"/></h2>
		<table class="{$tableClasses}">
			<thead class="{$theadClasses}">
			<tr class="{$headRowClasses}">
				<th class="{$thClasses}">Type</th>
				<th class="{$thClasses}">Locale</th>
				<th class="{$thClasses}">RecordDelimiter</th>
				<th class="{$thClasses}">DefaultDelimiter</th>
				<th class="{$thClasses}">RecordSize</th>
			</tr>
			</thead>
			<tbody class="{$tbodyClasses}">
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
					<xsl:if test="not(@recordSize)">&#160;</xsl:if>
					<xsl:value-of select="@recordSize"/>
				</td>
			</tr>
			</tbody>
		</table>
		<h2>Fields</h2>
		<table class="{$tableClasses}">
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
			<tbody class="{$tbodyClasses}">
			<xsl:apply-templates/>
			</tbody>
		</table>
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
</xsl:stylesheet>
