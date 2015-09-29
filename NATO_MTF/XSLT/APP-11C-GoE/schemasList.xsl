<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:text>var schemaresources =[</xsl:text>
        <xsl:apply-templates select="NatoMsgs/Msg"/>
        <xsl:text>];</xsl:text>
    </xsl:template>
    
    <xsl:template match="Msg">
        <xsl:variable name="mid" select="translate(@name,' :.','')"/>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_msg.xsd')"/>
        <xsl:text>',</xsl:text>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_sets.xsd')"/>
        <xsl:text>',</xsl:text>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_composites.xsd')"/>
        <xsl:text>',</xsl:text>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_fields.xsd')"/>
        <xsl:text>',</xsl:text>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_Doc.html')"/>
        <xsl:text>',</xsl:text>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_Form.html')"/>
        <xsl:text>',</xsl:text>
    </xsl:template>
    
    <xsl:template match="Msg[last()]">
        <xsl:variable name="mid" select="translate(@name,' :.','')"/>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_msg.xsd')"/>
        <xsl:text>',</xsl:text>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_sets.xsd')"/>
        <xsl:text>',</xsl:text>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_composites.xsd')"/>
        <xsl:text>',</xsl:text>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_fields.xsd')"/>
        <xsl:text>',</xsl:text>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_Doc.html')"/>
        <xsl:text>',</xsl:text>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="concat($mid,'/',$mid,'_Form.html')"/>
        <xsl:text>'</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>