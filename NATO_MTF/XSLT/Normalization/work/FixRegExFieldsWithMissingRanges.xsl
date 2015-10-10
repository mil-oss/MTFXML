<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/TR/xpath-functions" exclude-result-prefixes="xsd" xml:lang="en-US" version="2.0">
	
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	<xsl:variable name="inputDoc" select="document('../Baseline_Schemas/fields.xsd')"/>
	<xsl:variable name="missing_ranges_xsd" select="document('../RegEx/FindRegExFieldsWithMissingRangesOut.xml')"/>
	
	<xsl:template match="/">
		<xsl:result-document href="../RegEx/FixRegExFieldsWithMissingRangesOut.xml">
			<xsl:apply-templates select="$inputDoc/node()"/>
		</xsl:result-document>
	</xsl:template>
	
	<xsl:template match="xsd:simpleType/xsd:restriction/xsd:pattern">
		<xsl:variable name="simpleTypeName"><xsl:value-of select="string(./ancestor-or-self::xsd:simpleType/@name)"/></xsl:variable>
		<xsl:variable name="simpleTypeNodes"><xsl:copy-of select="."/></xsl:variable>

		<xsl:variable name="replacementPattern">
			<xsl:for-each select="$missing_ranges_xsd/TYPES/Regex/RegexType">
				<xsl:variable name="missingRangeFieldName"><xsl:value-of select="string(@fieldName)"/></xsl:variable>
				<xsl:if test="string($simpleTypeName) = string($missingRangeFieldName)">
					<xsl:variable name="regex" select="./@regex"/>
					<xsl:variable name="min" select="./@minLength"/>
					<xsl:variable name="max" select="./@maxLength"/>
					<xsl:variable name="rangePattern"><xsl:value-of select="concat('{',concat($min,concat(',',concat($max,'}'))))"/></xsl:variable>
					<xsd:pattern><xsl:value-of select="concat($simpleTypeName,concat(': ',concat(string($regex),$rangePattern)))"/></xsd:pattern>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:if test="(string-length($replacementPattern) > 0) and ((compare($simpleTypeName,substring-before($replacementPattern,':'))) = 0)">
			<xsl:copy>
				<xsl:attribute name="value">	
					<xsl:value-of select="string(substring-after($replacementPattern,': '))"/>
				</xsl:attribute>
			</xsl:copy>
		</xsl:if>
		
		<xsl:if test="(string-length($replacementPattern) = 0)">
			<xsl:copy>
				<xsl:attribute name="value">	
					<xsl:value-of select="string(@value)"/>
				</xsl:attribute>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<!-- Copy all nodes and attributes from source doc -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!--<xsl:template match="text()"/>-->
</xsl:stylesheet>