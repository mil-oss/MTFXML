<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="Msgs" select="document('../../../XSD/GoE_Schema/GoE_messages.xsd')"/>
    <xsl:variable name="Segments" select="document('../../../XSD/GoE_Schema/GoE_segments.xsd')"/>
    <xsl:variable name="Sets" select="document('../../../XSD/GoE_Schema/GoE_sets.xsd')"/>
    <xsl:variable name="Fields" select="document('../../../XSD/GoE_Schema/GoE_fields.xsd')"/>
    <xsl:variable name="conflicts">
        <xsl:apply-templates select="$Fields/xsd:schema/*[@name]" mode="field"/>
    </xsl:variable>
    <xsl:template name="main">
        <xsl:result-document href="../../../XSD/GoE_Schema/name_conflicts.xml">
            <Name_Conflicts>
                <xsl:for-each select="$conflicts/*[@segment | @set]">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </Name_Conflicts>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="*" mode="field">
        <xsl:variable name="fname" select="@name"/>
        <conflict field="{@name}">
            <xsl:apply-templates select="$Segments/xsd:schema/*[@name = $fname]" mode="segment"/>
            <xsl:apply-templates select="$Sets/xsd:schema/*[@name = $fname]" mode="set"/>
        </conflict>
    </xsl:template>
    <xsl:template match="*" mode="segment">
        <xsl:attribute name="segment">
            <xsl:value-of select="@name"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*" mode="set">
        <xsl:attribute name="set">
            <xsl:value-of select="@name"/>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
