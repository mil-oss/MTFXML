<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes"/>

    <xsl:template name="getPath">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="make-path"/>
    </xsl:template>

    <xsl:template match="* | @*" mode="make-path">
        <xsl:apply-templates select="parent::*" mode="make-path"/>
        <xsl:text>/</xsl:text>
        <xsl:apply-templates select="." mode="make-name"/>
        <xsl:apply-templates select="@*" mode="make-predicate"/>
    </xsl:template>

    <xsl:template match="* | @*" mode="make-predicate">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates select="." mode="make-name"/>
        <xsl:text> = '</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>']</xsl:text>
    </xsl:template>

    <xsl:template match="*" mode="make-name">
        <xsl:value-of select="name()"/>
    </xsl:template>

    <xsl:template match="@*" mode="make-name">
        <xsl:text>@</xsl:text>
        <xsl:value-of select="name()"/>
    </xsl:template>

    <xsl:template match="@*[parent::xsd:schema]" mode="make-predicate"/>
    <xsl:template match="@name" mode="make-predicate"/>
    <!--<xsl:template match="@minOccurs" mode="make-predicate"/>
    <xsl:template match="@maxOccurs" mode="make-predicate"/>-->
    <xsl:template match="@base" mode="make-predicate"/>
    <xsl:template match="@nillable" mode="make-predicate"/>

</xsl:stylesheet>
