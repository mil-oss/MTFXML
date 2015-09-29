<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" indent="yes"/>
    
    <xsl:variable name="source" select="document('Segment_Name_Changes.xml')"/>
    <xsl:variable name="output" select="'Segment_Name_Changes.csv'"/>
    
    <xsl:variable name="ColNames">
        <xsl:value-of select="concat('Element','&#44;','Segment')"/>
        <xsl:for-each select="$source/*/*[1]/@*[position()&gt;1]">
            <xsl:value-of select="concat('&#44;',name())"/>
        </xsl:for-each>
        <xsl:text>&#13;</xsl:text>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:result-document href="{$output}">
        <xsl:value-of select="$ColNames"/>
        <xsl:apply-templates select="$source/*/*"/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:value-of select="name()"/>
        <xsl:for-each select="@*">
            <xsl:value-of select="concat('&#44;',replace(.,'&#44;',''))"/>
        </xsl:for-each>
        <xsl:text>&#13;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>