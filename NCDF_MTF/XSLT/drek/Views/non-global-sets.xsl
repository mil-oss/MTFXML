<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsd"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="ngsets">
        <xsl:apply-templates select="//*[xsd:annotation/xsd:appinfo/*:SetFormat/@SetFormatPositionName][not(@ref)]" mode="sets">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>
    
    <xsl:template match="/">
        <Non-Global-Sets>
            <xsl:for-each select="$ngsets/*">
                <xsl:variable name="nm" select="@name"/>
                <xsl:if test="not(preceding-sibling::*/@name=$nm)">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:for-each>
        </Non-Global-Sets>
    </xsl:template>
    
    <xsl:template match="*" mode="sets">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    
</xsl:stylesheet>