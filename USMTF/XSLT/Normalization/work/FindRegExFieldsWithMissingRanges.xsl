<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" xml:lang="en-US" version="2.0">
	
	<xsl:output method="xml" indent="yes"/>
	<xsl:variable name="newline" select="'&#10;'"/>
	<xsl:variable name="blankspace" select="'&#xA;'"/>
	
	<xsl:variable name="mtf_fields_xsd" select="document('../Baseline_Schemas/fields.xsd')"/>
	
	<xsl:variable name="types">
		<TYPES>
			<Regex>
				<xsl:apply-templates select="$mtf_fields_xsd/xsd:schema/xsd:simpleType[xsd:restriction/xsd:pattern]">
					<xsl:sort select="/xsd:restriction/xsd:pattern/@value"/>
				</xsl:apply-templates>
			</Regex>
		</TYPES>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:result-document href="../RegEx/FindRegExFieldsWithMissingRangesOut.xml">
			<xsl:apply-templates select="$types/*" mode="sort">
				<xsl:sort select="@name" order="descending" data-type="text"/>
			</xsl:apply-templates>
		</xsl:result-document>
	</xsl:template>
	
	<xsl:template match="*" mode="sort">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="sort"/>
			<xsl:apply-templates select="*" mode="sort">
				<xsl:sort select="@name" order="descending" data-type="text"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*" mode="sort">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="xsd:schema/xsd:simpleType[xsd:restriction/xsd:pattern]">
		<xsl:variable name="regex">
			<xsl:value-of select="string(xsd:restriction/xsd:pattern/@value)"/>
		</xsl:variable>
		<xsl:variable name="elementName">
			<xsl:value-of select="@name"/>
		</xsl:variable>
		<xsl:variable name="minLength">
			<xsl:value-of select="string(xsd:restriction/parent::xsd:simpleType/xsd:annotation/xsd:appinfo/*:MinimumLength)"/>
		</xsl:variable>
		<xsl:variable name="maxLength">
			<xsl:value-of select="string(xsd:restriction/parent::xsd:simpleType/xsd:annotation/xsd:appinfo/*:MaximumLength)"/>
		</xsl:variable>
		<xsl:if
			test="(not(contains($regex,'{')) and not(contains($regex,'}')))">
			<xsl:element name="RegexType">
				<xsl:attribute name="regex">
					<xsl:value-of select="$regex"/>
				</xsl:attribute>
				<xsl:attribute name="fieldName">
					<xsl:value-of select="$elementName"/>
				</xsl:attribute>
				<xsl:attribute name="minLength">
					<xsl:value-of select="$minLength"/>
				</xsl:attribute>
				<xsl:attribute name="maxLength">
					<xsl:value-of select="$maxLength"/>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>