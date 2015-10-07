<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="mtfmsgs" select="document('../../XSD/GoE_Schema/GoE_messages.xsd')"/>
    <xsl:variable name="out" select="'../../XSD/GoE_Schema/GoE_Rules.xml'"/>

    <xsl:template match="/">
        <MTF>
        <xsl:result-document href="{$out}">
            <xsl:apply-templates select="$mtfmsgs/xsd:schema/xsd:complexType"/>
        </xsl:result-document>
        </MTF>
    </xsl:template>

    <xsl:template match="xsd:complexType">
        <MSG>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo"/>
        </MSG>
    </xsl:template>
    
    <xsl:template match="xsd:appinfo">
        <Annotations>
            <xsl:apply-templates select="*"/>
        </Annotations>
    </xsl:template>
    

    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>
