<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:inf="urn:mtf:mil:6040b:appinfo"
    xmlns:ism="urn:us:gov:ic:ism"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    
    
    
    <xsl:template match="/">
        <Test>
            <xsl:apply-templates select="//*[ends-with(@name,'GeneralTextType')]"/>
        </Test>
        
    </xsl:template>

    <!--IDENTITY-->
    <xsl:template match="*">
            <xsl:element name="{name()}">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="text()"/>
                <xsl:apply-templates select="*"/>
            </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:copy copy-namespaces="no"/>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
</xsl:stylesheet>