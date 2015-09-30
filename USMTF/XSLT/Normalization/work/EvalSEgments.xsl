<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="set" select="document('../XSD/GoE_Schemas/GoE_sets.xsd')"/>
    
    <xsl:template match="/">
        <Sets>
            <xsl:apply-templates select="$set/xsd:schema/xsd:complexType[not(xsd:complexContent/xsd:extension/@base='SetBaseType')]"/>
        </Sets>
    </xsl:template>
    
    <xsl:template match="xsd:complexType">
        <Set name="{@name}"/>
    </xsl:template>
    
</xsl:stylesheet>